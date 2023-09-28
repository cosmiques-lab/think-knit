create or replace package pkg_lavori as
    procedure insert_tipo_lavori (l_nome varchar2);
    /**

      mancano:

      insert modello -> ora base
      insert lavoro (id modello, nome lavoro, tipo_lavoro, tipo_strumento)
      add filato (lavoro, filato_id)
            -> modifica anche il filato (flag intero)

      insert jacquard_color (color code, color rgb)
      insert jacquard (con schema, da pensare come)
      add jacquard a lavoro (id lavoro, id jacquard)



     */
end pkg_lavori;

create or replace package body pkg_lavori as

    /**
     *
     */
    procedure insert_tipo_lavori (l_nome varchar2)
    is
        cl_proc_name    varchar2(200 char) := 'pkg_lavori.insert_tipo_lavori';
        l_new_id    NUMBER(10, 0);
        fl_exists   CHAR(1 CHAR);
    BEGIN
        pkg_log.info(cl_proc_name, 'insert tipo lavori ' || l_nome);

        fl_exists := 0;
        select 1
            into fl_exists
        from k_tipo_lavori
        where tipo_nome = l_nome;

        if fl_exists = 0 then
            select max(tipo_id) + 1
                into l_new_id
            from k_tipo_lavori;

            insert into k_tipo_lavori
                        (tipo_id,
                         tipo_nome,
                         dt_last_mod)
                values (l_new_id,
                        l_nome,
                        sysdate);
            commit;
        else
            pkg_log.error(cl_proc_name, 'tipo lavoro gia esistente ' || l_nome);
        end if;
    end insert_tipo_lavori;

end pkg_lavori;