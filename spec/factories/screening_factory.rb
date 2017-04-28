# frozen_string_literal: true
FactoryGirl.define do
  factory :screening do
    name { FFaker::Lorem.words(3).join(' ') }
    started_at { 4.days.ago }
    ended_at { 3.days.ago }
    incident_county do
      %w(
        alameda
        alpine
        amador
        butte
        calaveras
        colusa
        contra_Costa
        del_norte
        el_dorado
        fresno
        glenn
        humboldt
        imperial
        inyo
        kern
        kings
        lake
        lassen
        los_angeles
        madera
        marin
        mariposa
        mendocino
        merced
        modoc
        mono
        monterey
        napa
        nevada
        orange
        placer
        plumas
        riverside
        sacramento
        san_benito
        san_bernardino
        san_diego
        san_francisco
        san_joaquin
        san_luis_Obispo
        san_mateo
        santa_barbara
        santa_clara
        santa_cruz
        shasta
        sierra
        siskiyou
        solano
        sonoma
        stanislaus
        sutter
        tehama
        trinity
        tulare
        tuolumne
        ventura
        yolo
        yuba
      ).sample
    end
    assignee { FFaker::Name.name }
    report_narrative { FFaker::Lorem.paragraph }
    incident_date { 3.days.ago.to_date }
    location_type do
      [
        "Child's Home",
        "Relative's Home",
        'BDDS',
        'Camp',
        'Day Care',
        'Foster Home',
        'Hospital',
        'In Public',
        'Juvenile Detention',
        'Other Home',
        'Other',
        'Residential',
        'School',
        'Unknown'
      ].sample
    end
    additional_information { FFaker::Lorem.paragraph }
    communication_method do
      %w(
        Email
        Fax
        Mail
        Online
        Phone
      ).sample
    end
  end
end
