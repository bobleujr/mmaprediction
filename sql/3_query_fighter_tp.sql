
CREATE OR REPLACE FUNCTION get_fighter_basics_tp(f1 text, f2 text, mycursor refcursor) RETURNS refcursor AS $$

  BEGIN
    OPEN mycursor FOR (select
      a.name as fighter1,
      d.name fighter2,
      EXTRACT(YEAR from (AGE(now(),a.birth_date))) as age_f1,
      a.reach as reach_f1,
      ft_to_cm(a.height) as height_f1,
      a.slpm as slpm_f1,
      a.stracc as strcc_f1,
      a.sapm as sapm_f1,
      a.strdef as strdef_f1,
      a.tdavg as tdavg_f1,
      a.tddef as tddef_f1,
      a.subavg as subavg_f1,


      EXTRACT(YEAR from (AGE(now(),d.birth_date))) as age_f2,
      d.reach as reach_f2,
      ft_to_cm(d.height) as height_f2,
      d.slpm as slpm_f2,
      d.stracc as strcc_f2,
      d.sapm as sapm_f2,
      d.strdef as strdef_f2,
      d.tdavg as tdavg_f2,
      d.tddef as tddef_f2,
      d.subavg as subavg_f2

      /*CASE
        WHEN a.hasher = b.fighter1_id
        THEN 1
        ELSE 0
      END as result*/


    from fighterdb_fightermetric a, fighterdb_fightermetric d

    where a.name = f1 and d.name = f2
    order by a.hasher);

    RETURN mycursor;
  END;
$$ LANGUAGE plpgsql;