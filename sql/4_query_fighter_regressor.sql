--DROP FUNCTION get_fighter_basics_regressor(text, refcursor);
CREATE OR REPLACE FUNCTION get_fighter_basics_regressor(fighter text, mycursor refcursor) RETURNS refcursor AS $$

  BEGIN
    OPEN mycursor FOR (select
      a.name as fighter1,
      d.name fighter2,
      EXTRACT(YEAR from (AGE(c.date,a.birth_date))) as age_f1,
      a.reach as reach_f1,
      ft_to_cm(a.height) as height_f1,
      a.slpm as slpm_f1,
      a.stracc as strcc_f1,
      a.sapm as sapm_f1,
      a.strdef as strdef_f1,
      a.tdavg as tdavg_f1,
      a.tddef as tddef_f1,
      a.subavg as subavg_f1,


      EXTRACT(YEAR from (AGE(c.date,d.birth_date))) as age_f2,
      d.reach as reach_f2,
      ft_to_cm(d.height) as height_f2,
      d.slpm as slpm_f2,
      d.stracc as strcc_f2,
      d.sapm as sapm_f2,
      d.strdef as strdef_f2,
      d.tdavg as tdavg_f2,
      d.tddef as tddef_f2,
      d.subavg as subavg_f2,

      CASE
        WHEN a.hash = b.fighter1_id
        THEN 0.99
        ELSE 0.01
      END as result


    from fighterdb_fightermetric a

    inner join fighterdb_fightmetric b
    on b.fighter1_id = a.hash or b.fighter2_id = a.hash

    inner join fighterdb_fightermetric d
    on d.hash = (
      CASE
        WHEN a.hash = b.fighter1_id
        THEN b.fighter2_id
        ELSE b.fighter1_id
      END
      )


    inner join fighterdb_eventmetric c
    on b.event_hash = c.hash

    where a.name = fighter
    order by a.hash);

    RETURN mycursor;
  END;
$$ LANGUAGE plpgsql;