--Grupo DiagnosCAR
/*
João Gabriel Boaventura Marques e Silva RM554874 1TDSB-2024
Lucas de Melo Pinho Pinheiro RM558791 1TDSB-2024
Lucas Leal das Chagas RM551124 1TDSB-2024
*/

-- 1. Relatório utilizando classificação de dados

    -- Relatório 1: Classificação de clientes por faixa etária
SELECT Nome_Cliente, Sobrenome_Cliente, 
TRUNC(MONTHS_BETWEEN(SYSDATE, DataNasc_Cliente) / 12) AS Idade,
    CASE 
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, DataNasc_Cliente) / 12) BETWEEN 18 AND 24 THEN '18-24 anos'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, DataNasc_Cliente) / 12) BETWEEN 25 AND 34 THEN '25-34 anos'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, DataNasc_Cliente) / 12) BETWEEN 35 AND 44 THEN '35-44 anos'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, DataNasc_Cliente) / 12) BETWEEN 45 AND 54 THEN '45-54 anos'
        ELSE '55 anos ou mais' END AS Faixa_Etaria
FROM Cliente ORDER BY Idade;

    -- Relatório 2: Classificação de oficinas por avaliação
SELECT Nome_Oficina, Avaliacao_Oficina,
    CASE 
        WHEN Avaliacao_Oficina >= 9 THEN 'Ótima'
        WHEN Avaliacao_Oficina < 9 AND Avaliacao_Oficina > 7.5 THEN 'Boa'
        WHEN Avaliacao_Oficina <= 7.5 AND Avaliacao_Oficina > 6 THEN 'OK'
        WHEN Avaliacao_Oficina <= 6 THEN 'Ruim'
    END "QUALIDADE DA OFICINA"
FROM Oficina ORDER BY Avaliacao_Oficina DESC;



------------------------------------------------------------------------------

-- 2. Relatório utilizando alguma função do tipo numérica simples
    
    --Relatório 1: Contagem de Oficinas por Classificação
SELECT 
    CASE 
        WHEN Avaliacao_Oficina >= 9 THEN 'Ótima'
        WHEN Avaliacao_Oficina < 9 AND Avaliacao_Oficina > 7.5 THEN 'Boa'
        WHEN Avaliacao_Oficina <= 7.5 AND Avaliacao_Oficina > 6 THEN 'OK'
        WHEN Avaliacao_Oficina <= 6 THEN 'Ruim'
        ELSE 'Sem Avaliação' 
    END AS Classificacao,
    COUNT(*) AS Total_Oficinas
FROM Oficina
GROUP BY 
    CASE 
        WHEN Avaliacao_Oficina >= 9 THEN 'Ótima'
        WHEN Avaliacao_Oficina < 9 AND Avaliacao_Oficina > 7.5 THEN 'Boa'
        WHEN Avaliacao_Oficina <= 7.5 AND Avaliacao_Oficina > 6 THEN 'OK'
        WHEN Avaliacao_Oficina <= 6 THEN 'Ruim'
        ELSE 'Sem Avaliação'
    END
ORDER BY 
    Total_Oficinas DESC;

    --Relatório 2: Relatório 6: Avaliação Máxima e Mínima das Oficina
SELECT 
    MAX(Avaliacao_Oficina) AS Avaliacao_Maxima,
    MIN(Avaliacao_Oficina) AS Avaliacao_Minima
FROM Oficina;


------------------------------------------------------------------------------

-- 3. Relatório utilizando alguma função de grupo

    --Relatório 1: Média de avaliações das oficinas por especialização
SELECT Especializacao_Oficina, ROUND(AVG(Avaliacao_Oficina), 2) AS Media_Avaliacao
FROM Oficina 
GROUP BY Especializacao_Oficina;

    --Relatório 2: Contagem de automóveis por cliente
SELECT Cliente_CPF_Cliente, COUNT(Placa_Automovel) AS Total_Automoveis
FROM Automovel GROUP BY Cliente_CPF_Cliente;
    
------------------------------------------------------------------------------

-- 4. Relatório utilizando subconsulta
    
    --Relatório 1: Nome das oficinas com avaliação superior à média geral
SELECT Nome_Oficina, Avaliacao_Oficina FROM Oficina
WHERE Avaliacao_Oficina > (SELECT AVG(Avaliacao_Oficina) FROM Oficina);

    --Relatório 2: Clientes que possuem veículos de ano recente
SELECT Nome_Cliente, Sobrenome_Cliente FROM Cliente
WHERE CPF_Cliente IN 
(SELECT Cliente_CPF_Cliente FROM Automovel WHERE Ano_Automovel > 2018);



------------------------------------------------------------------------------

-- 5. Relatório utilizando junção de tabelas

    --Relatório 1: Informações de clientes e os automóveis que possuem
SELECT c.Nome_Cliente, c.Sobrenome_Cliente, a.Placa_Automovel, 
a.Marca_Automovel, a.Modelo_Automovel, a.Ano_Automovel
FROM Cliente c JOIN Automovel a ON c.CPF_Cliente = a.Cliente_CPF_Cliente
ORDER BY Nome_Cliente;

    --Relatório 2: Peças disponíveis em lojas parceiras
SELECT p.Nome_Peca, p.Tipo_Peca, lp.Nome_Loja, lp.Endereco_Loja,
       lp.Avaliacao_Loja, lp.Especializacao_Loja
FROM Peca p
INNER JOIN Loja_Parceira lp ON p.Loja_Parceira_Endereco_Loja = lp.Endereco_Loja
ORDER BY p.Nome_Peca;


