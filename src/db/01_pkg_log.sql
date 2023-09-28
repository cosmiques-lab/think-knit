CREATE OR REPLACE PACKAGE PKG_LOG AS
    PROCEDURE INFO (L_SOURCE VARCHAR2,
                    L_MESSAGE VARCHAR2);
    PROCEDURE ERROR (L_SOURCE VARCHAR2,
                     L_MESSAGE VARCHAR2);
    PROCEDURE DEBUG (L_SOURCE VARCHAR2,
                     L_MESSAGE VARCHAR2);
END PKG_LOG;

-- TODO da gestire l'utente
CREATE OR REPLACE PACKAGE BODY PKG_LOG AS

    /**
     *
     */
    PROCEDURE INFO (L_SOURCE VARCHAR2,
                    L_MESSAGE VARCHAR2)
    IS
    BEGIN
        insert into k_log (log_id, log_type, log_source, log_message, log_date)
            values (sk_log.nextval,
                    'INFO',
                    l_source,
                    l_message,
                    sysdate);
        commit;
    END;

    /**
     *
     */
    PROCEDURE ERROR (L_SOURCE VARCHAR2,
                    L_MESSAGE VARCHAR2)
    IS
    BEGIN
        insert into k_log (log_id, log_type, log_source, log_message, log_date)
            values (sk_log.nextval,
                    'ERROR',
                    l_source,
                    l_message,
                    sysdate);
        commit;
    END;

    /**
     *
     */
    PROCEDURE DEBUG (L_SOURCE VARCHAR2,
                    L_MESSAGE VARCHAR2)
    IS
    BEGIN
        insert into k_log (log_id, log_type, log_source, log_message, log_date)
            values (sk_log.nextval,
                    'DEBUG',
                    l_source,
                    l_message,
                    sysdate);
        commit;
    END;
END;

CREATE OR REPLACE PACKAGE PKG_MAGAZZINO AS
    materiale_non_presente  exception;
    tensione_non_presente   exception;
    tipo_strumento_non_presente  exception;

    PROCEDURE INSERT_TIPO_MATERIALE (L_NOME VARCHAR2);
    PROCEDURE INSERT_TENSIONE (L_NOME VARCHAR2);
    PROCEDURE INSERT_TIPO_STRUMENTO (L_NOME VARCHAR2);

    PROCEDURE INSERT_FILATO (l_id_materiale     number,
                             l_lunghezza        number,
                             l_peso             number,
                             l_id_tensione      number,
                             l_colore           varchar2,
                             l_produttore       varchar2,
                             l_modello          varchar2,
                             l_dt_acquisto      date,
                             l_quantita         number,
                             l_misura_uncinetto number,
                             l_misura_ferro     number) ;

    PROCEDURE INSERT_STRUMENTO (l_id_tipo_strumento number,
                                l_misura            number);

END;