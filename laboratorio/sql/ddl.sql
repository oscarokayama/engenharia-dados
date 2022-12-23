--Arquivo de geração do ambiente de laboratório de dados nos postgres.

--Criação do banco laboratorio:

CREATE SCHEMA laboratorio AUTHORIZATION airflow;


--Criação da tabela de nomes:
CREATE TABLE laboratorio.nomes (
	nome varchar(500) NULL
);

--Criação de sequence de nomes:
CREATE SEQUENCE public.nome_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1;
	
--Criação da tabela de nomes com sequence:
CREATE TABLE laboratorio.nomes_id (
	id int4 NOT NULL DEFAULT nextval('nome_id_seq'::regclass),
	nome varchar NULL
);

--Criação da tabela de associado:
CREATE TABLE laboratorio.associado (
	id int4 NOT NULL,
	nome varchar NULL,
	sobrenome varchar NULL,
	idade int4 NULL,
	email varchar NULL,
	CONSTRAINT associado_pk PRIMARY KEY (id)
);

--Criação da tabela cartao:
CREATE TABLE laboratorio.cartao (
	id int4 NOT NULL,
	num_cartao varchar NOT NULL,
	nom_impresso varchar NOT NULL,
	id_conta int4 NOT NULL,
	id_associado int4 NOT NULL,
	CONSTRAINT cartao_pk PRIMARY KEY (id)
);
CREATE INDEX cartao_id_associado_idx ON laboratorio.cartao USING btree (id_associado);
CREATE INDEX cartao_id_conta_idx ON laboratorio.cartao USING btree (id_conta);

--Criação da tabela conta:
CREATE TABLE laboratorio.conta (
	id int4 NOT NULL,
	tipo varchar NOT NULL,
	data_criacao date NOT NULL,
	id_associado int4 NOT NULL,
	CONSTRAINT conta_pk PRIMARY KEY (id)
);
CREATE INDEX conta_id_associado_idx ON laboratorio.conta USING btree (id_associado);

--Criação da tabela movimento:
CREATE TABLE laboratorio.movimento (
	id int4 NOT NULL DEFAULT nextval('compras_id_seq'::regclass),
	vlr_transacao numeric(10, 2) NULL,
	des_transacao varchar NULL,
	data_movimento date NOT NULL,
	id_cartao int4 NOT NULL,
	CONSTRAINT movimento_pk PRIMARY KEY (id)
);
CREATE INDEX movimento_id_cartao_idx ON laboratorio.movimento USING btree (id_cartao);

--Criação da tabela de encerramento conta:
CREATE TABLE laboratorio.encerramento_conta (
	id int4 NULL,
	data_criacao date NULL,
	semente int4 NULL,
	data_encerramento date NULL,
	data_parou_comprar date NULL,
	dias_sem_compra int4 NULL
);

--Criação de sequence de compras:
CREATE SEQUENCE public.compras_id_seq;


--Criação de sequence de fatura:
CREATE SEQUENCE public.fatura_id_seq;

--Criação da tabela de fatura
CREATE TABLE laboratorio.fatura (
	id integer NOT NULL DEFAULT nextval('fatura_id_seq'::regclass),
	data_vencimento_fatura date NOT NULL,
	vlr_fatura decimal(10,2) NULL,
	data_pagamento_fatura date NULL,
	qtd_dias_atraso_pgto integer NOT NULL DEFAULT 0,
	id_cartao integer NOT NULL,
	CONSTRAINT fatura_pk PRIMARY KEY (id)
);
CREATE INDEX fatura_id_cartao_idx ON laboratorio.fatura (id_cartao);
COMMENT ON TABLE laboratorio.fatura IS 'Tabela de faturas dos cartoes';

-- Column comments

COMMENT ON COLUMN laboratorio.fatura.id IS 'Identificador da fatura';
COMMENT ON COLUMN laboratorio.fatura.data_vencimento_fatura IS 'Data de vencimento da fatura';
COMMENT ON COLUMN laboratorio.fatura.vlr_fatura IS 'Valor da fatura';
COMMENT ON COLUMN laboratorio.fatura.data_pagamento_fatura IS 'Data do pagamento da fatura';
COMMENT ON COLUMN laboratorio.fatura.qtd_dias_atraso_pgto IS 'Qtd. de dias de atraso do pagamento';
COMMENT ON COLUMN laboratorio.fatura.id_cartao IS 'Identificador do cartao';
