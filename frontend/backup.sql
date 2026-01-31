--
-- PostgreSQL database dump
--

\restrict V8EOdSKvEUHEwmQI1uUjQrQgfrjEYSZjEONhhbld1HdqnqGVdlDzufpV1b325eh

-- Dumped from database version 14.20 (Homebrew)
-- Dumped by pg_dump version 14.20 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.articles (
    article_id integer NOT NULL,
    title character varying NOT NULL,
    authors character varying,
    doi character varying
);


ALTER TABLE public.articles OWNER TO dosimetry_user;

--
-- Name: articles_article_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.articles_article_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articles_article_id_seq OWNER TO dosimetry_user;

--
-- Name: articles_article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.articles_article_id_seq OWNED BY public.articles.article_id;


--
-- Name: detectors; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.detectors (
    detector_id integer NOT NULL,
    detector_type character varying,
    model character varying,
    manufacturer character varying
);


ALTER TABLE public.detectors OWNER TO dosimetry_user;

--
-- Name: detectors_detector_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.detectors_detector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.detectors_detector_id_seq OWNER TO dosimetry_user;

--
-- Name: detectors_detector_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.detectors_detector_id_seq OWNED BY public.detectors.detector_id;


--
-- Name: donnees; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.donnees (
    data_id integer NOT NULL,
    experiment_id integer NOT NULL,
    data_type character varying NOT NULL,
    unit character varying,
    file_format character varying,
    file_path character varying NOT NULL,
    description character varying
);


ALTER TABLE public.donnees OWNER TO dosimetry_user;

--
-- Name: donnees_data_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.donnees_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donnees_data_id_seq OWNER TO dosimetry_user;

--
-- Name: donnees_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.donnees_data_id_seq OWNED BY public.donnees.data_id;


--
-- Name: experience_detector; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.experience_detector (
    experiment_id integer NOT NULL,
    detector_id integer NOT NULL,
    "position" character varying,
    depth character varying,
    orientation character varying
);


ALTER TABLE public.experience_detector OWNER TO dosimetry_user;

--
-- Name: experience_machine; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.experience_machine (
    experiment_id integer NOT NULL,
    machine_id integer NOT NULL,
    energy character varying,
    collimation character varying,
    settings character varying
);


ALTER TABLE public.experience_machine OWNER TO dosimetry_user;

--
-- Name: experience_phantom; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.experience_phantom (
    experiment_id integer NOT NULL,
    phantom_id integer NOT NULL
);


ALTER TABLE public.experience_phantom OWNER TO dosimetry_user;

--
-- Name: experiences; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.experiences (
    experiment_id integer NOT NULL,
    description character varying,
    article_id integer
);


ALTER TABLE public.experiences OWNER TO dosimetry_user;

--
-- Name: experiences_experiment_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.experiences_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.experiences_experiment_id_seq OWNER TO dosimetry_user;

--
-- Name: experiences_experiment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.experiences_experiment_id_seq OWNED BY public.experiences.experiment_id;


--
-- Name: machines; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.machines (
    machine_id integer NOT NULL,
    manufacturer character varying,
    model character varying NOT NULL,
    machine_type character varying
);


ALTER TABLE public.machines OWNER TO dosimetry_user;

--
-- Name: machines_machine_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.machines_machine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.machines_machine_id_seq OWNER TO dosimetry_user;

--
-- Name: machines_machine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;


--
-- Name: phantoms; Type: TABLE; Schema: public; Owner: dosimetry_user
--

CREATE TABLE public.phantoms (
    phantom_id integer NOT NULL,
    name character varying,
    phantom_type character varying,
    dimensions character varying,
    material character varying
);


ALTER TABLE public.phantoms OWNER TO dosimetry_user;

--
-- Name: phantoms_phantom_id_seq; Type: SEQUENCE; Schema: public; Owner: dosimetry_user
--

CREATE SEQUENCE public.phantoms_phantom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phantoms_phantom_id_seq OWNER TO dosimetry_user;

--
-- Name: phantoms_phantom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dosimetry_user
--

ALTER SEQUENCE public.phantoms_phantom_id_seq OWNED BY public.phantoms.phantom_id;


--
-- Name: articles article_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.articles ALTER COLUMN article_id SET DEFAULT nextval('public.articles_article_id_seq'::regclass);


--
-- Name: detectors detector_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.detectors ALTER COLUMN detector_id SET DEFAULT nextval('public.detectors_detector_id_seq'::regclass);


--
-- Name: donnees data_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.donnees ALTER COLUMN data_id SET DEFAULT nextval('public.donnees_data_id_seq'::regclass);


--
-- Name: experiences experiment_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experiences ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiences_experiment_id_seq'::regclass);


--
-- Name: machines machine_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);


--
-- Name: phantoms phantom_id; Type: DEFAULT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.phantoms ALTER COLUMN phantom_id SET DEFAULT nextval('public.phantoms_phantom_id_seq'::regclass);


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.articles (article_id, title, authors, doi) FROM stdin;
1	Out-of-field dose measurements	Doe et al.	10.1234/test
3	Out-of-field dose measurements	Me et al.	10.61092/gzxy-sxvq
5	Another out-of-field dose measurements	Me et al.	10.61092/a9jw-6hnd
7	Out-of-field dose measurements	Doe et al.	10.1234/gzxy-sxvq
8	Out-of-field dose measurements	Me et al.	10.4321/ewpq-b87t
9	Out-of-field dose measurements	Doe et al.	10.1234/test2
10	Another article	Me, Benoît	10.1234/test3
11	Another article 2	Me & Benoît	10.1234/test4
12	Another article 3	Me & Benoît	10.1234/test5
13	Another article 4	Me & Benoît	10.1234/test6
14	Another article 5	Me & Benoît	10.1234/test7
15	Another article 6	Me & Benoît	10.1234/test8
16	Title	Rd	10.2345/6789
17	Title	Author	10.2323/2323
18	Title	Author	10.4321/5678
19	Title	Author	10.1234/test101
20	Title202	Author202	10.1202/202
21	Title303	Author303	10.1303/303
22	Title404	Author404	10.1404/404
23	Title505	Author505	10.1505/505
24	Title606	Author606	10.1606/606
25	Title808	Author808	10.1808/808
26	Title909	Author909	10.1909/909
27	Test101	Author101	10.1234/Test101
28	Test202	Test202	10.1234/Test202
\.


--
-- Data for Name: detectors; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.detectors (detector_id, detector_type, model, manufacturer) FROM stdin;
1	Type	Model	Manufacturer
2	Type	Model	Manufacturer
3	Type 2	Model	Manufacturer
4	Type101	Model101	Manufacturer101
5	Type202	Model202	Manufacturer202
6	Type303	Model303	Manufacturer303
7	Type404	Model404	Manufacturer404
8	Type505	Model505	Manufacturer505
9	Type606	Model606	Manufacturer606
10	Type808	Model808	Manufacturer808
11	Type909	Model909	Manufacturer909
12	Type909 2	Model909	Manufacturer909
13	Test101	Test101	Test101
14	Test202	Test202	Test202
\.


--
-- Data for Name: donnees; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.donnees (data_id, experiment_id, data_type, unit, file_format, file_path, description) FROM stdin;
1	1	Position	mm	csv	data/uploads/1_Varian iX extended profiles.csv	Data from Peet et al. 
2	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
3	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
4	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
5	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
6	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
7	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
8	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
9	20	Test101	Gy	xlsx	data/uploads/20_programme_Adam.xlsx	Test101
10	21	Test202	Gy	jpg	data/uploads/21_photo_boeuf.jpg	Test202
\.


--
-- Data for Name: experience_detector; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.experience_detector (experiment_id, detector_id, "position", depth, orientation) FROM stdin;
11	3	Position	Depth	Orientation
12	4	Position101	Depth101	Orientation101
13	5	Position202	Depth202	Orientation202
14	6	Position303	Depth303	Orientation303
15	7	Position404	Depth404	Orientation404
16	8	Position505	Depth505	Orientation505
17	9	Position606	Depth606	Orientation606
18	10	Position808	Depth808	Orientation808
19	11	Position909	Depth909	Orientation909
19	12	Position909	Depth909	Orientation909
20	13	Test101	Test101	Test101
21	14	Test202	Test202	Test202
\.


--
-- Data for Name: experience_machine; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.experience_machine (experiment_id, machine_id, energy, collimation, settings) FROM stdin;
1	1	Energy	Collimation	Settings
7	3	Energy	Collimation	\N
8	4	Energy	Collimation	Settings
9	5	Rd	Rd	
10	6	Energy	Collimation	Settings
11	7	Energy	Collimation	Settings
12	8	Energy101	Collimation101	Settings101
13	9	Energy202	Collimation202	Settings202
14	10	Energy303	Collimation303	Settings303
15	11	Energy404	Collimation404	Settings404
16	12	Energy505	Collimation505	Settings505
17	13	Energy606	Collimation606	Settings606
18	14	Energy808	Collimation808	Settings808
19	15	Energy909	Collimation909	Settings909
20	16	Test101	Test101	Test101
21	17	Test202	Test202	Test202
\.


--
-- Data for Name: experience_phantom; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.experience_phantom (experiment_id, phantom_id) FROM stdin;
7	4
11	5
12	6
13	7
14	8
15	9
16	10
17	11
18	12
19	13
20	14
21	15
\.


--
-- Data for Name: experiences; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.experiences (experiment_id, description, article_id) FROM stdin;
1	Out-of-field dose measurement	1
2	Out-of-field dose measurement	1
3	Out-of-field dose measurement	1
4	Out-of-field dose measurement	1
5	An experiment	12
6	Another experiment	13
7	Another experiment	14
8	Another experiment	15
9	Rd	16
10	Description	17
11	Description	18
12	Description101	19
13	Description202	20
14	Description303	21
15	Description404	22
16	Description505	23
17	Description606	24
18	Description808	25
19	Descritpion909	26
20	Test101	27
21	Test202	28
\.


--
-- Data for Name: machines; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.machines (machine_id, manufacturer, model, machine_type) FROM stdin;
1	Manufacturer	Model	Type
2	Manufacturer	Model	Type
3	Manufacturer	Model	\N
4	Manufacturer	Model	Type 2
5	Rd	Rd	Rd
6	Manufacturer	Model	Type 3
7	Manufacturer	Model	Type 4
8	Manufacturer101	Model101	Type101
9	Manufacturer202	Model202	Type202
10	Manufacturer303	Model303	Type303
11	Manufacturer404	Model404	Type404
12	Manufacturer505	Model505	Type505
13	Manufacturer606	Model606	Type606
14	Manufacturer808	Model808	Type808
15	Manufacturer909	Model909	Type909
16	Test101	Test101	Test101
17	Test202	Test202	Test202
\.


--
-- Data for Name: phantoms; Type: TABLE DATA; Schema: public; Owner: dosimetry_user
--

COPY public.phantoms (phantom_id, name, phantom_type, dimensions, material) FROM stdin;
1	Name	Type	Dimensions	Material
2	Name	Type	Dimensions	Material
3	Name	Type	Dimensions	Material
4	Phantom	\N	\N	Material
5	Name	Type	10x10x10	Material
6	Name101	Type101	101x101x101	Material101
7	Name202	Type202	202x202x202	Material202
8	Name303	Type303	303x303x303	Material303
9	Name404	Type404	404x404x404	Material404
10	Name505	Type505	505x505x505	Material505
11	Name606	Type606	606x606x606	Material606
12	Name808	Type808	808x808x808	Material808
13	Name909	Type909	909x909x909	Material909
14	Test101	Test101	1x1x1	Test101
15	Test202	Test202	2x2x2	Test202
\.


--
-- Name: articles_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.articles_article_id_seq', 28, true);


--
-- Name: detectors_detector_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.detectors_detector_id_seq', 14, true);


--
-- Name: donnees_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.donnees_data_id_seq', 10, true);


--
-- Name: experiences_experiment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.experiences_experiment_id_seq', 21, true);


--
-- Name: machines_machine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.machines_machine_id_seq', 17, true);


--
-- Name: phantoms_phantom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dosimetry_user
--

SELECT pg_catalog.setval('public.phantoms_phantom_id_seq', 15, true);


--
-- Name: articles articles_doi_key; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_doi_key UNIQUE (doi);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (article_id);


--
-- Name: detectors detectors_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.detectors
    ADD CONSTRAINT detectors_pkey PRIMARY KEY (detector_id);


--
-- Name: donnees donnees_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.donnees
    ADD CONSTRAINT donnees_pkey PRIMARY KEY (data_id);


--
-- Name: experience_detector experience_detector_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_detector
    ADD CONSTRAINT experience_detector_pkey PRIMARY KEY (experiment_id, detector_id);


--
-- Name: experience_machine experience_machine_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_machine
    ADD CONSTRAINT experience_machine_pkey PRIMARY KEY (experiment_id, machine_id);


--
-- Name: experience_phantom experience_phantom_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_phantom
    ADD CONSTRAINT experience_phantom_pkey PRIMARY KEY (experiment_id, phantom_id);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (experiment_id);


--
-- Name: machines machines_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);


--
-- Name: phantoms phantoms_pkey; Type: CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.phantoms
    ADD CONSTRAINT phantoms_pkey PRIMARY KEY (phantom_id);


--
-- Name: ix_articles_article_id; Type: INDEX; Schema: public; Owner: dosimetry_user
--

CREATE INDEX ix_articles_article_id ON public.articles USING btree (article_id);


--
-- Name: ix_donnees_data_id; Type: INDEX; Schema: public; Owner: dosimetry_user
--

CREATE INDEX ix_donnees_data_id ON public.donnees USING btree (data_id);


--
-- Name: ix_experiences_experiment_id; Type: INDEX; Schema: public; Owner: dosimetry_user
--

CREATE INDEX ix_experiences_experiment_id ON public.experiences USING btree (experiment_id);


--
-- Name: ix_machines_machine_id; Type: INDEX; Schema: public; Owner: dosimetry_user
--

CREATE INDEX ix_machines_machine_id ON public.machines USING btree (machine_id);


--
-- Name: donnees donnees_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.donnees
    ADD CONSTRAINT donnees_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiences(experiment_id);


--
-- Name: experience_detector experience_detector_detector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_detector
    ADD CONSTRAINT experience_detector_detector_id_fkey FOREIGN KEY (detector_id) REFERENCES public.detectors(detector_id);


--
-- Name: experience_detector experience_detector_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_detector
    ADD CONSTRAINT experience_detector_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiences(experiment_id);


--
-- Name: experience_machine experience_machine_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_machine
    ADD CONSTRAINT experience_machine_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiences(experiment_id);


--
-- Name: experience_machine experience_machine_machine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_machine
    ADD CONSTRAINT experience_machine_machine_id_fkey FOREIGN KEY (machine_id) REFERENCES public.machines(machine_id);


--
-- Name: experience_phantom experience_phantom_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_phantom
    ADD CONSTRAINT experience_phantom_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiences(experiment_id);


--
-- Name: experience_phantom experience_phantom_phantom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experience_phantom
    ADD CONSTRAINT experience_phantom_phantom_id_fkey FOREIGN KEY (phantom_id) REFERENCES public.phantoms(phantom_id);


--
-- Name: experiences experiences_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dosimetry_user
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(article_id);


--
-- PostgreSQL database dump complete
--

\unrestrict V8EOdSKvEUHEwmQI1uUjQrQgfrjEYSZjEONhhbld1HdqnqGVdlDzufpV1b325eh

