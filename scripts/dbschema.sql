--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: vw_mp_refresh_table(); Type: FUNCTION; Schema: public; Owner: waze
--

CREATE FUNCTION vw_mp_refresh_table() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  drop table if exists vw_mp;
  create table vw_mp as
    select mp.id, mp.resolved_by, mp.resolved_on, mp.weight, st_x(mp.position) as longitude, st_y(mp.position) as latitude, mp.resolution, mp.city_id from mp;
end;
$$;


ALTER FUNCTION public.vw_mp_refresh_table() OWNER TO waze;

--
-- Name: vw_places_refresh_table(); Type: FUNCTION; Schema: public; Owner: waze
--

CREATE FUNCTION vw_places_refresh_table() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  drop table if exists vw_places;
  create table vw_places as
    select id, name, street_id, created_on, created_by, updated_on, updated_by, st_x(position) as longitude, st_y(position) as latitude, lock, approved, residential, category, ad_locked, city_id from places;
  create index idx_places_city_id on vw_places (city_id nulls last);
end;
$$;


ALTER FUNCTION public.vw_places_refresh_table() OWNER TO waze;

--
-- Name: vw_pu_refresh_table(); Type: FUNCTION; Schema: public; Owner: waze
--

CREATE FUNCTION vw_pu_refresh_table() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  drop table if exists vw_pu;
  create table vw_pu as
    select p.id as id,
           pu.created_by as created_by,
           pu.created_on as created_on,
           ST_X(pu.position) as longitude,
           ST_Y(pu.position) as latitude,
           pu.staff as staff,
           coalesce(p.name, '[No Name]'::character varying) as name,
           pu.city_id as city_id
    from places p, pu
    where p.id = pu.place_id;
end;
$$;


ALTER FUNCTION public.vw_pu_refresh_table() OWNER TO waze;

--
-- Name: vw_ur_refresh_table(); Type: FUNCTION; Schema: public; Owner: waze
--

CREATE FUNCTION vw_ur_refresh_table() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  drop table if exists vw_ur;
  create table vw_ur as
    select id, comments, last_comment, last_comment_on, last_comment_by, first_comment_on, resolved_by, resolved_on, created_on, st_x(position) as longitude, st_y(position) as latitude, resolution, city_id from ur;
    create index idx_ur_city_id on vw_ur (city_id nulls last);
end;
$$;


ALTER FUNCTION public.vw_ur_refresh_table() OWNER TO waze;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: areas_cities; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE areas_cities (
    area_id integer,
    city_id integer
);


ALTER TABLE public.areas_cities OWNER TO waze;

--
-- Name: areas_mapraid; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE areas_mapraid (
    id integer NOT NULL,
    name character varying(100),
    map_name character varying(50),
    geom geometry(MultiPolygon,4326)
);


ALTER TABLE public.areas_mapraid OWNER TO waze;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying(50),
    isempty boolean,
    state_id integer
);


ALTER TABLE public.cities OWNER TO waze;

--
-- Name: cities_mapraid; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE cities_mapraid (
    gid integer NOT NULL,
    name character varying(49),
    geom geometry(MultiPolygon,4326),
    city_id integer,
    area_id integer
);


ALTER TABLE public.cities_mapraid OWNER TO waze;

--
-- Name: cities_mapraid_gid_seq; Type: SEQUENCE; Schema: public; Owner: waze
--

CREATE SEQUENCE cities_mapraid_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_mapraid_gid_seq OWNER TO waze;

--
-- Name: cities_mapraid_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waze
--

ALTER SEQUENCE cities_mapraid_gid_seq OWNED BY cities_mapraid.gid;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.countries OWNER TO waze;

--
-- Name: mp; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE mp (
    id character varying(20) NOT NULL,
    resolved_by integer,
    resolved_on timestamp without time zone,
    weight integer,
    "position" geometry(Point,4326),
    resolution integer,
    city_id integer
);


ALTER TABLE public.mp OWNER TO waze;

--
-- Name: places; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE places (
    id character varying(50) NOT NULL,
    name character varying(100),
    street_id integer,
    created_on timestamp without time zone,
    created_by integer,
    updated_on timestamp without time zone,
    updated_by integer,
    "position" geometry(Point,4326),
    lock integer,
    approved boolean,
    residential boolean,
    category character varying(40),
    ad_locked boolean,
    city_id character varying(7)
);


ALTER TABLE public.places OWNER TO waze;

--
-- Name: pu; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE pu (
    id character varying(60) NOT NULL,
    created_by integer,
    created_on timestamp without time zone,
    "position" geometry(Point,4326),
    staff boolean,
    city_id integer,
    place_id character varying(50)
);


ALTER TABLE public.pu OWNER TO waze;

--
-- Name: segments; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE segments (
    id integer NOT NULL,
    latitude real,
    longitude real,
    length integer,
    level smallint,
    last_edit_on timestamp without time zone,
    last_edit_by integer,
    lock smallint,
    connected boolean,
    street_id integer,
    roadtype smallint,
    dc_density smallint,
    fwdmaxspeed integer,
    revmaxspeed integer,
    fwddirection boolean,
    revdirection boolean,
    city_id integer,
    cross_segment boolean,
    area_id integer,
    fwdmaxspeedunverified boolean,
    revmaxspeedunverified boolean
);


ALTER TABLE public.segments OWNER TO waze;

--
-- Name: segments2; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE segments2 (
    id integer NOT NULL,
    geom geometry(LineString,4674),
    length integer,
    level smallint,
    last_edit_on timestamp with time zone,
    last_edit_by integer,
    lock smallint,
    connected boolean,
    street_id integer,
    roadtype smallint,
    dc_density smallint,
    fwdmaxspeed integer,
    revmaxspeed integer,
    fwddirection boolean,
    revdirection boolean,
    city_id integer,
    cross_segment boolean
);


ALTER TABLE public.segments2 OWNER TO waze;

--
-- Name: states; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE states (
    id integer NOT NULL,
    name character varying(50),
    country_id integer,
    abbreviation character varying(2),
    updated_at timestamp without time zone
);


ALTER TABLE public.states OWNER TO waze;

--
-- Name: states_shapes; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE states_shapes (
    gid integer NOT NULL,
    id_0 numeric(10,0),
    iso character varying(3),
    name_0 character varying(75),
    id_1 numeric(10,0),
    name_1 character varying(75),
    hasc_1 character varying(15),
    ccn_1 numeric(10,0),
    cca_1 character varying(254),
    type_1 character varying(50),
    engtype_1 character varying(50),
    nl_name_1 character varying(50),
    varname_1 character varying(150),
    geom geometry(MultiPolygon,4326)
);


ALTER TABLE public.states_shapes OWNER TO waze;

--
-- Name: states_shapes_gid_seq; Type: SEQUENCE; Schema: public; Owner: waze
--

CREATE SEQUENCE states_shapes_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.states_shapes_gid_seq OWNER TO waze;

--
-- Name: states_shapes_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: waze
--

ALTER SEQUENCE states_shapes_gid_seq OWNED BY states_shapes.gid;


--
-- Name: streets; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE streets (
    id integer NOT NULL,
    name character varying(100),
    isempty boolean,
    city_id integer
);


ALTER TABLE public.streets OWNER TO waze;

--
-- Name: updates; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE updates (
    updated_at timestamp with time zone,
    object character varying(20) NOT NULL
);


ALTER TABLE public.updates OWNER TO waze;

--
-- Name: ur; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE ur (
    id integer NOT NULL,
    comments integer,
    last_comment text,
    last_comment_on timestamp with time zone,
    last_comment_by integer,
    first_comment_on timestamp with time zone,
    resolved_by integer,
    resolved_on timestamp with time zone,
    created_on timestamp with time zone,
    "position" geometry(Point,4326),
    resolution integer,
    city_id integer
);


ALTER TABLE public.ur OWNER TO waze;

--
-- Name: users; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(50),
    rank integer
);


ALTER TABLE public.users OWNER TO waze;

--
-- Name: vw_mp; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE vw_mp (
    id character varying(20),
    resolved_by integer,
    resolved_on timestamp without time zone,
    weight integer,
    longitude double precision,
    latitude double precision,
    resolution integer,
    city_id integer
);


ALTER TABLE public.vw_mp OWNER TO waze;

--
-- Name: vw_pu; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE vw_pu (
    id character varying(50),
    created_by integer,
    created_on timestamp without time zone,
    longitude double precision,
    latitude double precision,
    staff boolean,
    name character varying,
    city_id integer
);


ALTER TABLE public.vw_pu OWNER TO waze;

--
-- Name: vw_segments; Type: MATERIALIZED VIEW; Schema: public; Owner: waze; Tablespace: 
--

CREATE MATERIALIZED VIEW vw_segments AS
 SELECT segments.id,
    segments.latitude,
    segments.longitude,
    segments.length,
    segments.level,
    segments.last_edit_on,
    segments.last_edit_by,
    segments.lock,
    segments.connected,
    segments.street_id,
    segments.roadtype,
    segments.dc_density,
    segments.fwdmaxspeed,
    segments.revmaxspeed,
    segments.fwddirection,
    segments.revdirection,
    segments.city_id,
    segments.cross_segment,
    segments.area_id,
    segments.fwdmaxspeedunverified,
    segments.revmaxspeedunverified
   FROM segments
  WITH NO DATA;


ALTER TABLE public.vw_segments OWNER TO waze;

--
-- Name: vw_streets; Type: MATERIALIZED VIEW; Schema: public; Owner: waze; Tablespace: 
--

CREATE MATERIALIZED VIEW vw_streets AS
 SELECT streets.id,
    streets.name,
    streets.isempty,
    streets.city_id
   FROM streets
  WITH NO DATA;


ALTER TABLE public.vw_streets OWNER TO waze;

--
-- Name: vw_ur; Type: TABLE; Schema: public; Owner: waze; Tablespace: 
--

CREATE TABLE vw_ur (
    id integer,
    comments integer,
    last_comment text,
    last_comment_on timestamp with time zone,
    last_comment_by integer,
    first_comment_on timestamp with time zone,
    resolved_by integer,
    resolved_on timestamp with time zone,
    created_on timestamp with time zone,
    longitude double precision,
    latitude double precision,
    resolution integer,
    city_id integer
);


ALTER TABLE public.vw_ur OWNER TO waze;

--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: waze
--

ALTER TABLE ONLY cities_mapraid ALTER COLUMN gid SET DEFAULT nextval('cities_mapraid_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: waze
--

ALTER TABLE ONLY states_shapes ALTER COLUMN gid SET DEFAULT nextval('states_shapes_gid_seq'::regclass);


--
-- Name: areas_mapraid_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY areas_mapraid
    ADD CONSTRAINT areas_mapraid_pkey PRIMARY KEY (id);


--
-- Name: cities_mapraid_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY cities_mapraid
    ADD CONSTRAINT cities_mapraid_pkey PRIMARY KEY (gid);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: mp_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY mp
    ADD CONSTRAINT mp_pkey PRIMARY KEY (id);


--
-- Name: pk_atualizacao; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY updates
    ADD CONSTRAINT pk_atualizacao PRIMARY KEY (object);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: pu_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY pu
    ADD CONSTRAINT pu_pkey PRIMARY KEY (id);


--
-- Name: segments2_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY segments2
    ADD CONSTRAINT segments2_pkey PRIMARY KEY (id);


--
-- Name: segments_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY segments
    ADD CONSTRAINT segments_pkey PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: states_shapes_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY states_shapes
    ADD CONSTRAINT states_shapes_pkey PRIMARY KEY (gid);


--
-- Name: streets_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY streets
    ADD CONSTRAINT streets_pkey PRIMARY KEY (id);


--
-- Name: ur_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY ur
    ADD CONSTRAINT ur_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: waze; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_segments_area; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_segments_area ON segments USING btree (area_id);


--
-- Name: idx_segments_city; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_segments_city ON segments USING btree (city_id);


--
-- Name: idx_segments_latitude; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_segments_latitude ON segments USING btree (latitude);


--
-- Name: idx_segments_longitude; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_segments_longitude ON segments USING btree (longitude);


--
-- Name: idx_segments_roadtype; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_segments_roadtype ON segments USING btree (roadtype);


--
-- Name: idx_ur_city_id; Type: INDEX; Schema: public; Owner: waze; Tablespace: 
--

CREATE INDEX idx_ur_city_id ON vw_ur USING btree (city_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

