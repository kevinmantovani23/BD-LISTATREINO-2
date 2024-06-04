--1. Consultar a quantidade, valor total e valor total com desconto (25%) dos itens comprados par Maria Clara.

SELECT SUM(pd.quantidade) as quantidade, SUM(pt.valor_unitario) as valortotal,
	   SUM(pt.valor_unitario *0.75) as valordesconto
FROM pedido pd, cliente cl, produto pt
WHERE pd.cod_cli = cl.codigo AND
	  pd.cod_prod = pt.codigo AND
	  cl.nome = 'Maria Clara'
GROUP BY pd.cod_cli

--2. Consultar quais brinquedos não tem itens em estoque.
SELECT pt.nome
FROM produto pt, fornecedor fr
WHERE pt.cod_forn = fr.codigo AND
	  qtd_estoque = 0 AND
	  fr.atividade LIKE 'Brinquedo%'

--3. Consultar quais nome e descrições de produtos que não estão em pedidos
SELECT pt.nome, pt.descricao
FROM produto pt
LEFT OUTER JOIN pedido pd
ON pt.codigo = pd.cod_prod
WHERE pd.cod_prod is NULL

--4. Alterar a quantidade em estoque do faqueiro para 10 peças.
UPDATE produto
SET qtd_estoque = 10
WHERE nome = 'Faqueiro'

--5. Consultar Quantos clientes tem mais de 40 anos.
SELECT nome
FROM cliente
WHERE (DATEDIFF(YEAR, data_nasc, GETDATE()) > 40)

--6. Consultar Nome e telefone (Formatado XXXX-XXXX) dos fornecedores de Brinquedos e Chocolate.
SELECT fr.nome, SUBSTRING(fr.telefone, 1, 4) + '-' + SUBSTRING(fr.telefone,5,8) as telefone
FROM fornecedor fr
WHERE fr.atividade = 'Brinquedos' OR
	  fr.atividade = 'Chocolate'

--7. Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
SELECT pt.nome, 
	CASE
	WHEN pt.valor_unitario < 50
	THEN pt.valor_unitario * 0.75 
	ELSE pt.valor_unitario
	END as valor
FROM produto pt

--8. Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00
SELECT pt.nome, 
	CASE
	WHEN pt.valor_unitario > 100
	THEN pt.valor_unitario * 1.10 
	ELSE pt.valor_unitario
	END as valor
FROM produto pt

--9. Consultar desconto de 15% no valor total de cada produto da venda 99001.
SELECT pt.nome, SUM(pt.valor_unitario * 0.85) as valor_desconto
FROM produto pt, pedido pd
WHERE pd.cod_prod = pt.codigo AND
	  pd.codigo = 99001
GROUP BY pt.nome

--10. Consultar Código do pedido, nome do cliente e idade atual do cliente
SELECT MAX(pd.codigo) as codigo, cl.nome, DATEDIFF(YEAR, cl.data_nasc, GETDATE()) as idade
FROM pedido pd, cliente cl
WHERE pd.cod_cli = cl.codigo
GROUP BY cl.nome, cl.data_nasc


--11. Consultar o nome do fornecedor do produto mais caro
SELECT fr.nome
FROM fornecedor fr, produto pt
WHERE pt.cod_forn = fr.codigo AND
	  pt.valor_unitario IN
	  (
	   SELECT MAX(valor_unitario)
	   FROM produto
	  )

--12. Consultar a média dos valores cujos produtos ainda estão em estoque
SELECT pd.nome, AVG(pd.valor_unitario) as media
FROM produto pd
WHERE pd.qtd_estoque > 0
GROUP BY pd.nome

--13. Consultar o nome do cliente, endereço composto por logradouro e número, o valor unitário do produto, 
--o valor total (Quantidade * valor unitario) da compra do cliente de nome Maria Clara
SELECT cl.nome, cl.logradouro + ' ' + CONVERT(VARCHAR(4), cl.numero) as endereco, pt.valor_unitario,
	   SUM(pt.valor_unitario * pd.quantidade) as valor_total
FROM cliente cl, produto pt, pedido pd
WHERE pd.cod_cli = cl.codigo AND
	  pd.cod_prod = pt.codigo AND
	  cl.nome = 'Maria Clara'
GROUP BY cl.nome, pt.valor_unitario, cl.logradouro, cl.numero

--14. Considerando que o pedido de Maria Clara foi entregue 15/03/2003, consultar quantos dias houve de atraso
SELECT DISTINCT DATEDIFF(DAY, pd.previsao_ent, '2023-03-15') as dias_atraso
FROM cliente cl, pedido pd
WHERE cl.codigo = pd.cod_cli AND
	  cl.nome = 'Maria Clara'

--15. Consultar qual a nova data de entrega para o pedido de Alberto% sabendo que se pediu 9 dias a mais.
SELECT DISTINCT DATEADD(DAY, 9, pd.previsao_ent) as nova_data
FROM cliente cl, pedido pd
WHERE cl.codigo = pd.cod_cli AND
	  cl.nome LIKE 'Alberto%'
