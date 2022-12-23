-- target.associado definition

-- Drop table

-- DROP TABLE target.associado;

CREATE TABLE target.associado (
	id int4 NOT NULL, -- Identificador do associado
	nome text NULL, -- Nome do associado
	sobrenome text NULL, -- Sobrenome do associado
	idade int4 NULL, -- Idade do associado
	email text NULL, -- E-mail do associado
	CONSTRAINT associado_pk PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN target.associado.id IS 'Identificador do associado';
COMMENT ON COLUMN target.associado.nome IS 'Nome do associado';
COMMENT ON COLUMN target.associado.sobrenome IS 'Sobrenome do associado';
COMMENT ON COLUMN target.associado.idade IS 'Idade do associado';
COMMENT ON COLUMN target.associado.email IS 'E-mail do associado';


-- target.cartao definition

-- Drop table

-- DROP TABLE target.cartao;

CREATE TABLE target.cartao (
	id int4 NOT NULL, -- Identificador do cartao
	num_cartao text NULL, -- Numero do cartao
	nom_impresso text NULL, -- Nome impresso no cartao
	id_conta int4 NOT NULL, -- Identificador da conta corrente
	id_associado int4 NOT NULL, -- Identificador do associado
	CONSTRAINT cartao_pk PRIMARY KEY (id)
);
CREATE INDEX cartao_id_associado_idx ON target.cartao USING btree (id_associado);
CREATE INDEX cartao_id_conta_idx ON target.cartao USING btree (id_conta);

-- Column comments

COMMENT ON COLUMN target.cartao.id IS 'Identificador do cartao';
COMMENT ON COLUMN target.cartao.num_cartao IS 'Numero do cartao';
COMMENT ON COLUMN target.cartao.nom_impresso IS 'Nome impresso no cartao';
COMMENT ON COLUMN target.cartao.id_conta IS 'Identificador da conta corrente';
COMMENT ON COLUMN target.cartao.id_associado IS 'Identificador do associado';


-- target.conta definition

-- Drop table

-- DROP TABLE target.conta;

CREATE TABLE target.conta (
	id int4 NOT NULL, -- Identificador da conta corrente
	tipo text NULL, -- Tipo da conta corrente
	data_criacao date NULL, -- Data da criacao
	id_associado int4 NOT NULL, -- Identificador do associado
	CONSTRAINT conta_pk PRIMARY KEY (id)
);
CREATE INDEX conta_id_associado_idx ON target.conta USING btree (id_associado);

-- Column comments

COMMENT ON COLUMN target.conta.id IS 'Identificador da conta corrente';
COMMENT ON COLUMN target.conta.tipo IS 'Tipo da conta corrente';
COMMENT ON COLUMN target.conta.data_criacao IS 'Data da criacao';
COMMENT ON COLUMN target.conta.id_associado IS 'Identificador do associado';


-- target.encerramento_conta definition

-- Drop table

-- DROP TABLE target.encerramento_conta;

CREATE TABLE target.encerramento_conta (
	id int4 NULL, -- Identificador da conta
	data_criacao date NULL, -- Data de criacao da conta
	data_encerramento date NULL -- Data de encerramento da conta
);

-- Column comments

COMMENT ON COLUMN target.encerramento_conta.id IS 'Identificador da conta';
COMMENT ON COLUMN target.encerramento_conta.data_criacao IS 'Data de criacao da conta';
COMMENT ON COLUMN target.encerramento_conta.data_encerramento IS 'Data de encerramento da conta';


-- target.fatura definition

-- Drop table

-- DROP TABLE target.fatura;

CREATE TABLE target.fatura (
	id int4 NOT NULL, -- Identificador da fatura
	data_vencimento_fatura date NULL, -- Data de vencimento da fatura
	vlr_fatura numeric(10, 2) NULL, -- Valor da fatura
	data_pagamento_fatura date NULL, -- Data do pagamento da fatura
	qtd_dias_atraso_pgto int4 NULL, -- Qtd. de dias de atraso do pagamento
	id_cartao int4 NOT NULL, -- Identificador do cartao
	CONSTRAINT fatura_pk PRIMARY KEY (id)
);
CREATE INDEX fatura_id_cartao_idx ON target.fatura USING btree (id_cartao);

-- Column comments

COMMENT ON COLUMN target.fatura.id IS 'Identificador da fatura';
COMMENT ON COLUMN target.fatura.data_vencimento_fatura IS 'Data de vencimento da fatura';
COMMENT ON COLUMN target.fatura.vlr_fatura IS 'Valor da fatura';
COMMENT ON COLUMN target.fatura.data_pagamento_fatura IS 'Data do pagamento da fatura';
COMMENT ON COLUMN target.fatura.qtd_dias_atraso_pgto IS 'Qtd. de dias de atraso do pagamento';
COMMENT ON COLUMN target.fatura.id_cartao IS 'Identificador do cartao';


-- target.movimento definition

-- Drop table

-- DROP TABLE target.movimento;

CREATE TABLE target.movimento (
	id int4 NOT NULL, -- Identificador da transacao do cartao
	vlr_transacao numeric(10, 2) NULL, -- Valor da transacao
	des_transacao text NULL, -- Descricao transacao
	data_movimento date NULL, -- Data movimento
	id_cartao int4 NOT NULL, -- Identificador do cartao
	CONSTRAINT movimento_pk PRIMARY KEY (id)
);
CREATE INDEX movimento_id_cartao_idx ON target.movimento USING btree (id_cartao);

-- Column comments

COMMENT ON COLUMN target.movimento.id IS 'Identificador da transacao do cartao';
COMMENT ON COLUMN target.movimento.vlr_transacao IS 'Valor da transacao';
COMMENT ON COLUMN target.movimento.des_transacao IS 'Descricao transacao';
COMMENT ON COLUMN target.movimento.data_movimento IS 'Data movimento';
COMMENT ON COLUMN target.movimento.id_cartao IS 'Identificador do cartao';