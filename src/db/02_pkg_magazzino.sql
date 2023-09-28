CREATE OR REPLACE PACKAGE BODY PKG_MAGAZZINO AS

    /**
     *
     */
    PROCEDURE INSERT_TIPO_MATERIALE (L_NOME VARCHAR2)
    IS
        cl_proc_name    varchar2(200 char) := 'pkg_magazzino.insert_tipo_materiale';
        l_new_id    NUMBER(10, 0);
        fl_exists   CHAR(1 CHAR);
    BEGIN
        pkg_log.info(cl_proc_name, 'insert tipo_materiale ' || l_nome);

        fl_exists := 0;
        select 1
            into fl_exists
        from K_TIPO_MATERIALE
        where materiale_nome = l_nome;

        if fl_exists = 0 then
            select max(materiale_id) + 1
                into l_new_id
            from k_tipo_materiale;

            insert into k_tipo_materiale
                        (materiale_id,
                         materiale_nome,
                         dt_last_mod)
                values (l_new_id,
                        l_nome,
                        sysdate);

            commit;
        else
            pkg_log.error(cl_proc_name, 'tipo_materiale gia esistente ' || l_nome);
        end if;
    END;

    /**
     *
     */
    PROCEDURE INSERT_TENSIONE (L_NOME VARCHAR2)
    IS
        cl_proc_name    varchar2(200 char) := 'pkg_magazzino.insert_tensione';
        l_new_id    NUMBER(10, 0);
    BEGIN
        pkg_log.info(cl_proc_name, 'insert tensione ' || l_nome);

        select max(tensione_id) + 1
            into l_new_id
        from k_tensioni;

        insert into k_tensioni (TENSIONE_ID, TENSIONE_SCHEMA, DT_LAST_MOD)
            values (l_new_id,
                    l_nome,
                    sysdate);
        commit;
    END;

    /**
     *
     */
    PROCEDURE INSERT_TIPO_STRUMENTO (L_NOME VARCHAR2)
    IS
        cl_proc_name    varchar2(200 char) := 'pkg_magazzino.insert_tipo_strumento';
        l_new_id    NUMBER(10, 0);
        fl_exists   CHAR(1 CHAR);
    BEGIN
        pkg_log.info(cl_proc_name, 'insert tipo strumento ' || l_nome);

        fl_exists := 0;
        select 1
            into fl_exists
        from k_tipo_strumento
        where tipo_nome = l_nome;

        if fl_exists = 0 then
            select max(tipo_id) + 1
                into l_new_id
            from k_tipo_strumento;

            insert into k_tipo_strumento
                        (tipo_id,
                         tipo_nome,
                         dt_last_mod)
                values (l_new_id,
                        l_nome,
                        sysdate);
            commit;
        else
            pkg_log.error(cl_proc_name, 'tipo strumento gia esistente ' || l_nome);
        end if;
    END;

    /**
     *
     */
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
                             l_misura_ferro     number)
    IS
        cl_proc_name        varchar2(200 char)  := 'pkg_magazzino.insert_filato';
        fl_is_intero        char(1 char)        := '1';
        fl_exist_materiale  char(1 char)        := '0';
        fl_exists_tensione  char(1 char)        := '0';

        l_id_uncinetto      number(10, 0)       := 1;
        l_id_ferri          number(10, 0)       := 2;
    BEGIN
        pkg_log.INFO(cl_proc_name, 'start insert filato in magazzino');

        select '1'
            into fl_exist_materiale
        from k_tipo_materiale
        where materiale_id = l_id_materiale;

        if fl_exist_materiale = '0'
        then
            pkg_log.error(cl_proc_name, 'tipo materiale non presente a db [id: ' || l_id_materiale || ']');
            raise materiale_non_presente;
        end if;

        select '1'
            into fl_exists_tensione
        from k_tensioni
        where tensione_id = l_id_tensione;

        if fl_exists_tensione = '0'
        then
            pkg_log.error(cl_proc_name, 'tensione non presente a db [id: ' || l_id_tensione || ']');
            raise tensione_non_presente;
        end if;

        for i in 1..l_quantita
        loop
            insert into k_filati
                values (sk_filati.nextval,
                        l_id_materiale,
                        l_lunghezza,
                        l_peso,
                        i,
                        l_id_tensione,
                        l_colore,
                        l_produttore,
                        l_modello,
                        l_dt_acquisto,
                        fl_is_intero,
                        sysdate);

            if l_misura_ferro is not null then
                insert into k_strumenti_consigliati
                    values (sk_filati.currval,
                            l_id_ferri,
                            l_misura_ferro,
                            sysdate);
            end if;

            if l_misura_uncinetto is not null then
                insert into K_STRUMENTI_CONSIGLIATI
                    values (sk_filati.currval,
                            l_id_uncinetto,
                            l_misura_uncinetto,
                            sysdate);
            end if;

            pkg_log.debug(cl_proc_name, 'inserito filato con id: ' || sk_filati.currval);

        end loop;

        pkg_log.INFO(cl_proc_name, 'fine inserimento filati');
        commit;
    END;

    PROCEDURE INSERT_STRUMENTO (l_id_tipo_strumento number,
                                l_misura            number)
    is
        cl_proc_name    varchar2(200 char)  := 'pkg_magazzino.insert_strumento';
        fl_exists_tipo  char(1 char) := '0';
    begin
        pkg_log.info(cl_proc_name, 'start insert strumento');

        select '1'
            into fl_exists_tipo
        from k_tipo_strumento
        where tipo_id = l_id_tipo_strumento;

        if fl_exists_tipo = '0'
        then
            pkg_log.error(cl_proc_name, 'tipo strumento non trovato. id=' || l_id_tipo_strumento);
            raise tipo_strumento_non_presente;
        end if;

        insert into k_strumenti
            values (sk_strumenti.nextval,
                    l_id_tipo_strumento,
                    l_misura,
                    sysdate);

        commit;
    end;

END;