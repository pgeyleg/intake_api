--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id character varying NOT NULL,
    street_address character varying,
    city character varying,
    state character varying,
    zip character varying,
    type character varying
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: allegations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE allegations (
    id integer NOT NULL,
    screening_id character varying,
    perpetrator_id character varying,
    victim_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    allegation_types character varying[]
);


--
-- Name: allegations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE allegations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allegations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE allegations_id_seq OWNED BY allegations.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cross_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cross_reports (
    id character varying NOT NULL,
    agency_name character varying,
    agency_type character varying,
    screening_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cross_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cross_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cross_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cross_reports_id_seq OWNED BY cross_reports.id;


--
-- Name: participant_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participant_addresses (
    id character varying NOT NULL,
    participant_id character varying,
    address_id character varying
);


--
-- Name: participant_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participant_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participant_addresses_id_seq OWNED BY participant_addresses.id;


--
-- Name: participant_phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participant_phone_numbers (
    id character varying NOT NULL,
    participant_id character varying,
    phone_number_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participant_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participant_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participant_phone_numbers_id_seq OWNED BY participant_phone_numbers.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participants (
    id character varying NOT NULL,
    date_of_birth date,
    first_name character varying,
    gender character varying,
    last_name character varying,
    ssn character varying,
    screening_id character varying,
    person_id character varying,
    roles character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participants_id_seq OWNED BY participants.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE people (
    id character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    gender character varying,
    ssn character varying,
    date_of_birth date,
    middle_name character varying,
    name_suffix character varying,
    languages character varying[] DEFAULT '{}'::character varying[],
    races json,
    ethnicity json
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: person_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE person_addresses (
    id character varying NOT NULL,
    person_id character varying,
    address_id character varying
);


--
-- Name: person_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_addresses_id_seq OWNED BY person_addresses.id;


--
-- Name: person_phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE person_phone_numbers (
    id character varying NOT NULL,
    person_id character varying,
    phone_number_id character varying
);


--
-- Name: person_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_phone_numbers_id_seq OWNED BY person_phone_numbers.id;


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phone_numbers (
    id character varying NOT NULL,
    number character varying,
    type character varying
);


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phone_numbers_id_seq OWNED BY phone_numbers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: screening_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE screening_addresses (
    id character varying NOT NULL,
    screening_id character varying,
    address_id character varying
);


--
-- Name: screening_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE screening_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: screening_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE screening_addresses_id_seq OWNED BY screening_addresses.id;


--
-- Name: screenings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE screenings (
    id character varying NOT NULL,
    reference character varying,
    ended_at timestamp without time zone,
    incident_date date,
    location_type character varying,
    communication_method character varying,
    name character varying,
    started_at timestamp without time zone,
    screening_decision character varying,
    incident_county character varying,
    report_narrative text,
    assignee character varying,
    additional_information character varying,
    screening_decision_detail character varying
);


--
-- Name: screenings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE screenings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: screenings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE screenings_id_seq OWNED BY screenings.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY allegations ALTER COLUMN id SET DEFAULT nextval('allegations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cross_reports ALTER COLUMN id SET DEFAULT nextval('cross_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participant_addresses ALTER COLUMN id SET DEFAULT nextval('participant_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participant_phone_numbers ALTER COLUMN id SET DEFAULT nextval('participant_phone_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_addresses ALTER COLUMN id SET DEFAULT nextval('person_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_phone_numbers ALTER COLUMN id SET DEFAULT nextval('person_phone_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phone_numbers ALTER COLUMN id SET DEFAULT nextval('phone_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY screening_addresses ALTER COLUMN id SET DEFAULT nextval('screening_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY screenings ALTER COLUMN id SET DEFAULT nextval('screenings_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: allegations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allegations
    ADD CONSTRAINT allegations_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cross_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cross_reports
    ADD CONSTRAINT cross_reports_pkey PRIMARY KEY (id);


--
-- Name: participant_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participant_addresses
    ADD CONSTRAINT participant_addresses_pkey PRIMARY KEY (id);


--
-- Name: participant_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participant_phone_numbers
    ADD CONSTRAINT participant_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: person_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_addresses
    ADD CONSTRAINT person_addresses_pkey PRIMARY KEY (id);


--
-- Name: person_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_phone_numbers
    ADD CONSTRAINT person_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: screening_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY screening_addresses
    ADD CONSTRAINT screening_addresses_pkey PRIMARY KEY (id);


--
-- Name: screenings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY screenings
    ADD CONSTRAINT screenings_pkey PRIMARY KEY (id);


--
-- Name: index_allegations_on_screening_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_allegations_on_screening_id ON allegations USING btree (screening_id);


--
-- Name: index_allegations_on_screening_perpetrator_victim; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_allegations_on_screening_perpetrator_victim ON allegations USING btree (screening_id, perpetrator_id, victim_id);


--
-- Name: index_cross_reports_on_screening_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cross_reports_on_screening_id ON cross_reports USING btree (screening_id);


--
-- Name: index_participant_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_addresses_on_address_id ON participant_addresses USING btree (address_id);


--
-- Name: index_participant_addresses_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_addresses_on_participant_id ON participant_addresses USING btree (participant_id);


--
-- Name: index_participant_phone_numbers_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_phone_numbers_on_participant_id ON participant_phone_numbers USING btree (participant_id);


--
-- Name: index_participant_phone_numbers_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_phone_numbers_on_phone_number_id ON participant_phone_numbers USING btree (phone_number_id);


--
-- Name: index_participants_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_person_id ON participants USING btree (person_id);


--
-- Name: index_participants_on_screening_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_screening_id ON participants USING btree (screening_id);


--
-- Name: index_person_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_addresses_on_address_id ON person_addresses USING btree (address_id);


--
-- Name: index_person_addresses_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_addresses_on_person_id ON person_addresses USING btree (person_id);


--
-- Name: index_person_phone_numbers_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_phone_numbers_on_person_id ON person_phone_numbers USING btree (person_id);


--
-- Name: index_person_phone_numbers_on_phone_number_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_phone_numbers_on_phone_number_id ON person_phone_numbers USING btree (phone_number_id);


--
-- Name: index_screening_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_screening_addresses_on_address_id ON screening_addresses USING btree (address_id);


--
-- Name: index_screening_addresses_on_screening_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_screening_addresses_on_screening_id ON screening_addresses USING btree (screening_id);


--
-- Name: fk_rails_21bacd85b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allegations
    ADD CONSTRAINT fk_rails_21bacd85b8 FOREIGN KEY (perpetrator_id) REFERENCES participants(id);


--
-- Name: fk_rails_681f7bdf1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allegations
    ADD CONSTRAINT fk_rails_681f7bdf1b FOREIGN KEY (victim_id) REFERENCES participants(id);


--
-- Name: fk_rails_ae53cbda2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cross_reports
    ADD CONSTRAINT fk_rails_ae53cbda2a FOREIGN KEY (screening_id) REFERENCES screenings(id);


--
-- Name: fk_rails_bb84f1ed75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allegations
    ADD CONSTRAINT fk_rails_bb84f1ed75 FOREIGN KEY (screening_id) REFERENCES screenings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160727210432'),
('20160808213209'),
('20160810212922'),
('20160817211617'),
('20160824142845'),
('20160902152935'),
('20160902185908'),
('20160902193705'),
('20160906201325'),
('20160914192750'),
('20160922191047'),
('20161011184741'),
('20161011203949'),
('20161011205146'),
('20161013183454'),
('20161013222844'),
('20161101235059'),
('20161102190951'),
('20161121112618'),
('20161123203048'),
('20161206160824'),
('20161206193420'),
('20161208232502'),
('20161222163255'),
('20170109102207'),
('20170110150042'),
('20170111142114'),
('20170119163207'),
('20170208174745'),
('20170221232217'),
('20170227192427'),
('20170306182111'),
('20170320225918'),
('20170324173331'),
('20170324184740'),
('20170324185122'),
('20170324204945'),
('20170329204444'),
('20170404204641'),
('20170406164348');


