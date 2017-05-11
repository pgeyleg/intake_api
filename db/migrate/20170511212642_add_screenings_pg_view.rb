class AddScreeningsPgView < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
         CREATE VIEW VW_SCREENING_HISTORY AS (
              SELECT
                  s."id" as screening_id,
                  alg."id" as allegation_id,
                  p."id" as participant_id,
                  p.person_id as person_legacy_id,
                  alg.allegation_types,
                  case when p."id" = alg.victim_id      then 1 end as is_alg_victim,
                  case when p."id" = alg.perpetrator_id then 1 end as is_alg_perp,
                  s.reference,
                  s.started_at,
                  s.ended_at,
                  s.incident_date,
                  s.location_type,
                  s.communication_method,
                  s."name" as screening_name,
                  s.screening_decision,
                  s.incident_county,
                  s.report_narrative,
                  s.assignee,
                  s.additional_information,
                  s.screening_decision_detail,
                  p.date_of_birth as birth_dt,
                  p.first_name,
                  p.last_name,
                  p.gender,
                  p.ssn,
                  p.roles,
                  case when (array_position(p.roles, 'Mandated Reporter')     is not null
                          or array_position(p.roles, 'Non-mandated Reporter') is not null
                          or array_position(p.roles, 'Anonymous Reporter')    is not null) then 1 else 0 end as is_reporter,
                  case when p."id" = alg.victim_id      or array_position(p.roles, 'Victim')      is not null then 1 else 0 end as is_victim,
                  case when p."id" = alg.perpetrator_id or array_position(p.roles, 'Perpetrator') is not null then 1 else 0 end as is_perpetrator,
                  pa."id" as partc_addr_id,
                  pa.participant_id as pa_partc_id,
                  adr."id" as address_id,
                  adr."type" as address_type,
                  adr.street_address,
                  adr.city,
                  adr."state",
                  adr.zip,
                  ppn.phone_number_id,
                  ppn.participant_id as ph_partc_id,
                  ph."number" as phone_number,
                  ph."type" as phone_type,
                  (select max(v.created_at) from versions v where
                      (v.item_type = 'Participant'            and   p."id" = cast(v.item_id as varchar))
                   or (v.item_type = 'Address'                and adr."id" = cast(v.item_id as varchar))
                   or (v.item_type = 'Allegation'             and alg."id" = v.item_id)
                   or (v.item_type = 'ParticipantAddress'     and  pa."id" = cast(v.item_id as varchar))
                   or (v.item_type = 'ParticipantPhoneNumber' and ppn."id" = cast(v.item_id as varchar))
                   or (v.item_type = 'PhoneNumber'            and  ph."id" = cast(v.item_id as varchar))
                   or (v.item_type = 'Screening'              and   s."id" = cast(v.item_id as varchar))
                  ) as last_chg
                  --,greatest(alg.created_at, alg.updated_at, ppn.created_at, ppn.updated_at) as last_chg
              FROM            screenings s
              LEFT OUTER JOIN allegations alg               on alg.screening_id = s."id"
              LEFT OUTER JOIN participants p                on p.screening_id = s."id" or p."id" = alg.victim_id or p."id" = alg.perpetrator_id
              LEFT OUTER JOIN participant_addresses pa      on pa.participant_id = p."id"
              LEFT OUTER JOIN addresses adr                 on adr."id" = pa.address_id and coalesce(adr.street_address, adr.city, adr.zip) is not null
              LEFT OUTER JOIN participant_phone_numbers ppn on ppn.participant_id = p."id"
              LEFT OUTER JOIN phone_numbers ph              on ph."id" = ppn.phone_number_id
            );
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW VW_SCREENING_HISTORY;
    SQL
  end
end
