
--Importar o arquivo nomes.csv na tabela laboratorio.nomes

--Rodar o seguinte script para inserção de dados na tabela nomes_id

insert into laboratorio.nomes_id (nome)
select nome
from laboratorio.nomes;

--Rodar o seguinte script para inserção de associado
insert into laboratorio.associado
select 
	id,
	nome,
	sobrenome,
	idade,
	lower(nome) || '.' || lower(sobrenome) || '@' || dominio
	
from (
	select 
		id,
		nome_completo,
		split_part(nome_completo, ' ', 1) as nome,
		split_part(nome_completo, ' ', 2) as sobrenome,
		floor(random()*(75-18+1))+18 as idade,
		case floor(random()*(5-1+1))+1
		when 1 then 'hotmail.com'
		when 2 then 'gmail.com'
		when 3 then 'yahoo.com.br'
		when 4 then 'uol.com.br'
		when 5 then 'terra.com.br'
		end as dominio
	from (
		select
			id,
			initcap(trim(
					replace(replace(replace(replace(replace(replace(replace(replace(lower(nome), 'dra.', ''), 'dr.', ''), 'sra.', ''), 'sr.', ''), ' da ', ' '), ' do ', ' '), ' das ', ' '), ' dos ', ' ')
				)
			) as nome_completo
		from laboratorio.nomes_id
	) as t1
) as t1

--Insere conta:
insert into laboratorio.conta
select
	id,
	'Conta Corrente',
	current_date - cast(floor(random()*(1825-30+1))+1 as integer),
	id
from laboratorio.associado


--Insere cartao
insert into laboratorio.cartao
select 
	id,
	num_cartao_1 || num_cartao_2 || num_cartao_3 || num_cartao_4 || num_cartao_5 as num_cartao,
	nome_impresso as nom_impresso,
	id as id_conta,
	id as id_associado
	
from (
	select
		id,
		UPPER(nome || ' ' || sobrenome) as nome_impresso,
		trim(to_char(cast((floor(random()*9-1+1))+1 as integer), '0')) as num_cartao_1,
		trim(to_char(cast((floor(random()*999-1+1))+1 as integer), '000')) as num_cartao_2,
		trim(to_char(idade, '0000')) as num_cartao_3,
		trim(to_char(id, '0000')) as num_cartao_4,
		trim(to_char(cast((floor(random()*9999-1+1))+1 as integer), '0000')) as num_cartao_5
	from laboratorio.associado
) as T1

--Insere dados de encerramento da conta:
insert into laboratorio.encerramento_conta 
select 
	id,
	data_criacao,
	semente,
	data_encerramento,
	data_parou_comprar,
	coalesce(data_encerramento, current_date) - data_parou_comprar as dias_sem_compra
from (
	select 
		id,
		data_criacao,
		semente,
		data_encerramento,
		case
		when data_encerramento is not null then data_encerramento - cast(floor(random()*(180))+180 as integer)
		when semente<=25 then current_date - cast(floor(random()*(600-180+1))+1 as integer)
		else null
		end as data_parou_comprar
		
	from (
		select 	
			id,
			data_criacao,
			semente,
			case
			when semente>5 then null
			else data_encerramento
			end as data_encerramento
		from (
			select 
				id,
				data_criacao,
				cast(floor(random()*(100-1))+1 as integer) as semente,
				current_date - cast(floor(random()*(180-30+1))+1 as integer) as data_encerramento
				
			from laboratorio.conta
		) as t1
	) as t1
) as t1

--Cria tabela de compras
drop table laboratorio.compras;
create table laboratorio.compras as 
select distinct 
	id,
	idade,
	dt_compra,
	((random()*(case when idade<20 then 100 when idade<30 then 300 else 500 end))+1)::decimal(10,2) as vl_compra,
	case cast(floor(random()*(6))+1 as integer)
	when 1 then 'Supermercado'
	when 2 then 'Restaurante'
	when 3 then 'Posto combustivel'
	when 4 then 'Pet shop'
	when 5 then 'Roupa'
	when 6 then 'Farmacia'
	end as ds_compra,
	dt_ultimo_dia,
	data_criacao,
	data_encerramento,
	data_parou_comprar,
	qt_compras_mes,
	qt_dia_compra,
	dia_compra
	
from (
		
	select distinct 
		id,
		idade,
		dt_ultimo_dia,
		data_criacao,
		data_encerramento,
		data_parou_comprar,
		qt_compras_mes,
		qt_dia_compra,
		dia_compra,
		dt_ultimo_dia - dia_compra as dt_compra
	from (
		select distinct 
			id,
			idade,
			dt_ultimo_dia,
			data_criacao,
			data_encerramento,
			data_parou_comprar,
			semente as qt_compras_mes,
			n_line.n as qt_dia_compra,
			cast(floor(random()*(29))+1 as integer) as dia_compra
			
		from (
		
			select distinct
				id,
				idade,
				dt_ultimo_dia,
				data_criacao,
				data_encerramento,
				data_parou_comprar,
				cast(floor(random()*(case when idade<20 then 5 when idade<30 then 10 else 15 end))+1 as integer) as semente
				
			from (
				select distinct
					enc.id,
					ass.idade,
					t_data.dt_ultimo_dia,
					enc.data_criacao,
					enc.data_encerramento,
					enc.data_parou_comprar
					
				from laboratorio.encerramento_conta enc
				
				inner join laboratorio.associado ass
				on ass.id=enc.id
				
				inner join (
					select 
						dt_dia,
						(date_trunc('month', dt_dia) + interval '1 month - 1 day')::date as dt_ultimo_dia
					from (
						select 
							(CAST('2018-01-01' AS DATE) + (n || ' day')::interval)::date as dt_dia
						from generate_series(0, 2000) n
					) as t1
					
					where dt_dia<current_date
				) as t_data
				on t_data.dt_dia between enc.data_criacao and coalesce(enc.data_parou_comprar, current_date)
			) as t1
		) as t1
		
		inner join (
			select 
				n
			from generate_series(1, 10) n
		) n_line
		on n_line.n<=semente
	) as t1
) as t1

where dt_compra between data_criacao and coalesce(data_parou_comprar, current_date)

order by id, dt_compra, dt_ultimo_dia, qt_compras_mes, qt_dia_compra

--Insere movimento:
ALTER SEQUENCE public.compras_id_seq RESTART WITH 1;
truncate laboratorio.movimento;
insert into laboratorio.movimento (vlr_transacao, des_transacao, data_movimento, id_cartao)
select 
	sum(vl_compra) as vl_compra,
	max(ds_compra) as ds_compra,
	dt_compra,
	id as id_cartao
	
from laboratorio.compras

group by dt_compra, id

order by id, dt_compra



--Insere dados na tabela de fatura:
ALTER SEQUENCE public.fatura_id_seq RESTART WITH 1;
truncate laboratorio.fatura;
insert into laboratorio.fatura (data_vencimento_fatura, vlr_fatura, data_pagamento_fatura, qtd_dias_atraso_pgto, id_cartao)
select
	dt_vencimento as data_vencimento_fatura,
	vlr_transacao as vlr_fatura,
	dt_pagamento as data_pagamento_fatura,
	qt_dias_atraso_pgto as qtd_dias_atraso_pgto,
	id as id_cartao
	
from (
	select 
		id,
		idade,
		dt_vencimento,
		pc_risco,
		vlr_transacao,
		vlr_transacao_risco,
		faixa_risco_nao_pgto,
		pc_risco_nao_pgto,
		case
		when dt_vencimento>=current_date then current_date
		when dt_pagamento<=current_date then dt_pagamento
		else current_date
		end as dt_pagamento,
		case
		when dt_vencimento>=current_date then 0
		when dt_pagamento-dt_vencimento<=0 then 0
		else dt_pagamento-dt_vencimento
		end as qt_dias_atraso_pgto
		
	from (
		select
			id,
			idade,
			to_date(ano_mes || '15', 'yyyymmdd') as dt_vencimento,
			pc_risco,
			vlr_transacao,
			vlr_transacao_risco,
			faixa_risco_nao_pgto,
			faixa_risco_nao_pgto-vlr_transacao_risco as pc_risco_nao_pgto,
			case
			when vlr_transacao_risco<0.01 then to_date(ano_mes || '15', 'yyyymmdd')
			when faixa_risco_nao_pgto-vlr_transacao_risco>pc_risco then to_date(ano_mes || '15', 'yyyymmdd')-cast(floor(random()*(5))+1 as integer)
			else to_date(ano_mes || '15', 'yyyymmdd')+cast(floor(random()*(90))+1 as integer)
			end as dt_pagamento
			
		from (
			select 
				ris.id,
				ris.idade,
				ris.ano_mes,
				ris.pc_risco,
				coalesce(mov.vlr_transacao, 0) as vlr_transacao,
				coalesce(mov.vlr_transacao, 0)/case
				when idade<20 then 5000
				when idade<25 then 10000
				when idade<30 then 30000
				when idade<35 then 40000
				when idade<40 then 50000
				else 100000 end as vlr_transacao_risco,
				case
				when idade<20 then 0.95
				when idade<25 then 0.97
				else 1 end::decimal(10,5) as faixa_risco_nao_pgto
			
			from (
				select 
					id,
					idade,
					faixa_risco,
					ano_mes,
					semente,
					faixa_risco/semente::decimal(10,5) as pc_risco
				from (
					select distinct
						id,
						idade,
						case
						when idade<20 then 30
						when idade<25 then 25
						when idade<30 then 10
						else 5 end as faixa_risco,
						to_char(dt_ultimo_dia, 'yyyymm') as ano_mes,
						cast(floor(random()*(
							case
							when idade<20 then 300
							when idade<25 then 1000
							when idade<30 then 5000
							when idade<35 then 7000
							when idade<40 then 9500
							else 10000 end
						))+1 as integer) as semente
						
					from (
						select distinct
							enc.id,
							ass.idade,
							t_data.dt_ultimo_dia,
							enc.data_criacao,
							enc.data_encerramento
							
						from laboratorio.encerramento_conta enc
						
						inner join laboratorio.associado ass
						on ass.id=enc.id
						
						inner join (
							select 
								dt_dia,
								(date_trunc('month', dt_dia) + interval '1 month - 1 day')::date as dt_ultimo_dia
							from (
								select 
									(CAST('2018-01-01' AS DATE) + (n || ' day')::interval)::date as dt_dia
								from generate_series(0, 2000) n
							) as t1
							
							where dt_dia<current_date
						) as t_data
						on t_data.dt_dia between enc.data_criacao and coalesce(enc.data_encerramento, current_date)
					) as t1
				) as t1
			) as ris
			
			left join (
				select 
					id_cartao,
					to_char(data_movimento, 'yyyymm') as ano_mes,
					sum(vlr_transacao) as vlr_transacao
				
				from laboratorio.movimento
				
				group by 1, 2
			) as mov
			on mov.id_cartao=ris.id
			and mov.ano_mes=ris.ano_mes
		) as t1	
	) as t1
) as t1;

--Insercao de registros -1, nao informado para integridade de relacionamento das tabelas:
insert into laboratorio.associado (id, nome, sobrenome, idade, email) values (-1, 'Nao localizado', 'Nao localizado', 0, 'Nao localizado');
insert into laboratorio.cartao (id, num_cartao, nom_impresso, id_conta, id_associado) values (-1, '-1', 'Nao localizado', -1, -1);
insert into laboratorio.conta (id, tipo, data_criacao, id_associado) values (-1, 'Nao localizado', '1900-01-01', -1);
insert into laboratorio.movimento (id, vlr_transacao, des_transacao, data_movimento, id_cartao) values (-1, null, 'Nao localizado', '1900-01-01', -1);
insert into laboratorio.fatura (id, data_vencimento_fatura, vlr_fatura, data_pagamento_fatura, qtd_dias_atraso_pgto, id_cartao) values (-1, '1900-01-01', null, '1900-01-01', 0, -1);


--Apagar alguns registros para ocorrer não integralidade dos dados:
--delete from laboratorio.associado
where id in (
	select cast(floor(random()*10000)+1 as integer)
	from generate_series(1, 50) n
);