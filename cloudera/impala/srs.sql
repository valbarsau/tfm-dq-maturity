-- Debido al tamanyo de la consulta hay que crear una tabla intermedia
DROP TABLE IF EXISTS dq_maturity.dsrs_covid_indonesia;
CREATE TABLE dq_maturity.dsrs_covid_indonesia AS
SELECT * FROM 
(
    /*Si el numero de registros con un nivel de madurez en RCPMR igual 4,
    es mayor igual o al 80% respecto del total del dataset, entonces el nivel de madurez
    agregado respecto de la dimension de Completeness es 4. En otro caso, si el numero de
    registros con un nivel de madurez mayor o igual a 3, es superior al 70%, entonces el
    nivel de madurez agregado respecto de esta dimension es 3. En otro caso, si la media
    aritmetica del nivel de madurez es mayor igual a 2, entonces el nivel de madurez
    agregado es 2. En otro caso, si dicha media sin decimales es 1, entonces el nivel
    agregado es 1. En otro caso, es 0.*/  
  SELECT *,
        CASE
            WHEN rcpmr_4_freq >= (rcpmr_registers_freq * 0.8)
              THEN 4
            WHEN rcpmr_3_freq >= (rcpmr_registers_freq * 0.7)
              THEN 3
            WHEN rcpmr_avg >= 2
              THEN 2
            WHEN floor(rcpmr_avg) = 1
              THEN 1
            ELSE 0
        END cpmsr
  FROM (
        SELECT SUM (
                      CASE
                        WHEN rcpmr = 4
                          THEN 1
                        ELSE 0
                      END
                  ) rcpmr_4_freq,
                SUM (
                      CASE
                        WHEN rcpmr = 3
                          THEN 1
                        ELSE 0
                      END
                  ) rcpmr_3_freq,
                COUNT(*) rcpmr_registers_freq,
                AVG(rcpmr) rcpmr_avg
        FROM dq_maturity.dataset_covid_indonesia_dmn
      ) aggregation_rcpmr
) agg_cpmsr
JOIN (
    /* Si el numero de registros con un nivel de madurez en RAMR igual 4, es
    mayor igual al 80% respecto del total del dataset, entonces el nivel de madurez agregado
    respecto de la dimension Accuracy es 4. En otro caso, si el numero de registros, con un
    nivel de madurez mayor o igual a 3 es superior al 60%, entonces el nivel de madurez
    agregado respecto de esta dimension es 3. En otro caso, si la media aritmetica del nivel
    de madurez es mayor igual a 2, entonces el nivel de madurez agregado es 2. En otro
    caso, si dicha media sin decimales es 1, entonces el nivel agregado es 1. En otro caso, es
    0.*/
        SELECT *,
              CASE
                  WHEN ramr_4_freq >= (ramr_registers_freq * 0.8)
                    THEN 4
                  WHEN ramr_3_freq >= (ramr_registers_freq * 0.6)
                    THEN 3
                  WHEN ramr_avg >= 2
                    THEN 2
                  WHEN floor(ramr_avg) = 1
                    THEN 1
                  ELSE 0
              END amsr
        FROM (
              SELECT SUM (
                            CASE
                              WHEN ramr = 4
                                THEN 1
                              ELSE 0
                            END
                        ) ramr_4_freq,
                      SUM (
                            CASE
                              WHEN ramr = 3
                                THEN 1
                              ELSE 0
                            END
                        ) ramr_3_freq,
                      COUNT(*) ramr_registers_freq,
                      AVG(ramr) ramr_avg
              FROM dq_maturity.dataset_covid_indonesia_dmn
            ) aggregation_ramr
        ) agg_amsr
JOIN (
        SELECT *,
              CASE
                  WHEN rcsmr_4_freq >= (rcsmr_registers_freq * 0.8)
                    THEN 4
                  WHEN rcsmr_3_freq >= (rcsmr_registers_freq * 0.6)
                    THEN 3
                  WHEN rcsmr_avg >= 2
                    THEN 2
                  WHEN floor(rcsmr_avg) = 1
                    THEN 1
                  ELSE 0
              END csmsr
        FROM (
              SELECT SUM (
                            CASE
                              WHEN rcsmr = 4
                                THEN 1
                              ELSE 0
                            END
                        ) rcsmr_4_freq,
                      SUM (
                            CASE
                              WHEN rcsmr = 3
                                THEN 1
                              ELSE 0
                            END
                        ) rcsmr_3_freq,
                      COUNT(*) rcsmr_registers_freq,
                      AVG(rcsmr) rcsmr_avg
              FROM dq_maturity.dataset_covid_indonesia_dmn
            ) aggregation_rcsmr
        ) agg_csmsr;

SELECT 
/*Si el nivel de madurez de ASR es igual o mayor a 3, entonces el dataset es
usable. En otro caso, no lo es*/
        CASE
            WHEN asr >= 3
                THEN 'To be used'
            ELSE 'Not to be used'
        END usr,
        *
FROM (        
        SELECT CAST(SPLIT_PART(asr_not_splitted, '-', 1) AS INT) asr,
            SPLIT_PART(asr_not_splitted, '-', 2) asr_desc,
            SPLIT_PART(asr_not_splitted, '-', 3) asr_dimension_to_review,
            *
        FROM (
            -- Implementa las reglas definidas tabularmente. Equivalente a RAR
                SELECT CASE
                        WHEN cpmsr = 4 
                            AND amsr = 4
                            AND csmsr = 4
                            THEN '4-Complete Quality-None' 
                        WHEN cpmsr = 4 
                            AND amsr = 4
                            AND csmsr = 3
                            THEN '4-Complete Quality-Consistency'
                        WHEN cpmsr = 4 
                            AND amsr = 3
                            AND csmsr = 4
                            THEN '4-Complete Quality-Accuracy'  
                        WHEN cpmsr = 4 
                            AND amsr = 3
                            AND csmsr = 3
                            THEN '3-High Quality-Accuracy'                  
                        WHEN cpmsr = 3
                            AND amsr IN (3, 4)
                            AND csmsr IN (3, 4)
                            THEN '3-High Quality-Completeness'
                        WHEN cpmsr IN (3, 4)
                            AND amsr IN (3, 4)
                            AND csmsr = 2
                            THEN '2-Medium Quality-Consistency'
                        WHEN cpmsr IN (3, 4)
                            AND amsr = 2
                            AND csmsr IN (2, 3, 4)
                            THEN '2-Medium Quality-Accuracy'
                        WHEN cpmsr IN (3, 4)
                            AND amsr IN (2, 3, 4)
                            AND csmsr IN (0, 1)
                            THEN '1-Low Quality-Consistency'
                        WHEN cpmsr IN (3, 4)
                            AND amsr = 1
                            AND csmsr IN (2, 3, 4)
                            THEN '1-Low Quality-Accuracy'
                        WHEN cpmsr = 2
                            AND amsr IN (2, 3, 4)
                            THEN '1-Low Quality-Completeness'
                        WHEN cpmsr = 4
                            AND amsr = 1
                            AND csmsr = 1
                            THEN '1-Low Quality-Accuracy'
                        WHEN cpmsr = 4
                            AND amsr = 1
                            AND csmsr = 0
                            THEN '0-No Quality-Accuracy'
                        WHEN cpmsr = 4
                            AND amsr = 0
                            THEN '0-No Quality-Accuracy'
                        WHEN cpmsr = 3
                            AND amsr = 1
                            AND csmsr IN (0, 1)
                            THEN '0-No Quality-Accuracy'
                        WHEN cpmsr = 3
                            AND amsr = 0
                            THEN '0-No Quality-Accuracy'
                        WHEN cpmsr = 2
                            AND amsr IN (0, 1)
                            THEN '0-No Quality-Completeness'
                        WHEN cpmsr IN (0, 1)
                            THEN '0-No Quality-Completeness'
                        ELSE '999-N/A-N/A'
                    END asr_not_splitted,
                    *
                FROM dq_maturity.dsrs_covid_indonesia
        ) asr_level
) usr_level;