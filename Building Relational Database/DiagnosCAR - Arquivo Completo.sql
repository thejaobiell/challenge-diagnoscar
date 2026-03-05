--Grupo DiagnosCAR
/*
João Gabriel Boaventura Marques e Silva RM554874 1TDSB-2024
Lucas de Melo Pinho Pinheiro RM558791 1TDSB-2024
Lucas Leal das Chagas RM551124 1TDSB-2024
*/
-------------------------------------------------------------------------------
--1ª Parte: Criação das Tabelas

DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Automovel CASCADE CONSTRAINTS;
DROP TABLE Chatbot CASCADE CONSTRAINTS;
DROP TABLE Pre_Diagnostico CASCADE CONSTRAINTS;
DROP TABLE Oficina CASCADE CONSTRAINTS;
DROP TABLE Loja_Parceira CASCADE CONSTRAINTS;
DROP TABLE Peca CASCADE CONSTRAINTS;
DROP TABLE Entrega CASCADE CONSTRAINTS;
DROP TABLE Tabela_de_Associacao CASCADE CONSTRAINTS;



CREATE TABLE Cliente (
    CPF_Cliente VARCHAR2(14) CONSTRAINT PK_Cliente PRIMARY KEY,
    CNH_Cliente VARCHAR2(11) CONSTRAINT CNH_Cliente UNIQUE,
    RG_Cliente VARCHAR2(12) CONSTRAINT RG_Cliente UNIQUE,
    Nome_Cliente VARCHAR2(100) CONSTRAINT Nome_Cliente NOT NULL,
    Sobrenome_Cliente VARCHAR2(100) CONSTRAINT Sobrenome_Cliente NOT NULL,
    DataNasc_Cliente DATE CONSTRAINT DataNasc_Cliente NOT NULL,
    Email_Cliente VARCHAR2(100) CONSTRAINT Email_Cliente UNIQUE,
    Senha_Cliente VARCHAR2(50) CONSTRAINT Senha_Cliente NOT NULL,
    Telefone_Cliente VARCHAR2(15) CONSTRAINT Telefone_Cliente UNIQUE,
    Endereco_Cliente VARCHAR2(200) CONSTRAINT Endereco_Cliente NOT NULL,
    
    CONSTRAINT CPF_Cliente CHECK (REGEXP_LIKE(CPF_Cliente, '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}$')),
    CONSTRAINT Telefone_Cliente_CHK CHECK (REGEXP_LIKE(Telefone_Cliente, '^\(\d{2}\) \d{4,5}-\d{4}$')),
    CONSTRAINT Email_Cliente_CHK CHECK (REGEXP_LIKE(Email_Cliente, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);



CREATE TABLE Automovel (
    Placa_Automovel VARCHAR2(7) CONSTRAINT PK_Automovel PRIMARY KEY,
    Marca_Automovel VARCHAR2(20) CONSTRAINT Marca_Automovel NOT NULL,
    Modelo_Automovel VARCHAR2(100) CONSTRAINT Modelo_Automovel NOT NULL,
    Ano_Automovel NUMBER(4) CONSTRAINT Ano_Automovel NOT NULL,
    Cliente_CPF_Cliente VARCHAR2(14),
    
    CONSTRAINT FK_Automovel_Cliente FOREIGN KEY (Cliente_CPF_Cliente) REFERENCES Cliente(CPF_Cliente)
);


CREATE TABLE Chatbot (
    ID_Chatbot VARCHAR2(1000) CONSTRAINT ID_Chatbot NOT NULL,
    Data_Chat DATE CONSTRAINT Horario_Chatbot NOT NULL,
    Plano VARCHAR2(10) CONSTRAINT Plano_Chatbot NOT NULL,
    Cliente_CPF_Cliente VARCHAR2(14),
    Placa_Automovel VARCHAR2(7),
    
    CONSTRAINT PK_Chatbot PRIMARY KEY (ID_Chatbot, Cliente_CPF_Cliente),
    CONSTRAINT FK_Chatbot_Cliente FOREIGN KEY (Cliente_CPF_Cliente) REFERENCES Cliente(CPF_Cliente),
    CONSTRAINT FK_Chatbot_Automovel FOREIGN KEY (Placa_Automovel) REFERENCES Automovel(Placa_Automovel)
);



CREATE TABLE Pre_Diagnostico (
    ID_PreDiagnostico VARCHAR2(1000) CONSTRAINT PK_PreDiagnostico PRIMARY KEY,
    Nivel_Diagnostico NUMBER(3) CONSTRAINT Nivel_PreDiagnostico NOT NULL,
    Diagnostico VARCHAR2(500) CONSTRAINT Diagnostico_PreDiagnostico NOT NULL,
    Assistente_ID_Chatbot VARCHAR2(1000) CONSTRAINT Assistente_PreDiagnostico NOT NULL,
    Cliente_CPF_Cliente VARCHAR2(14) CONSTRAINT Cliente_PreDiagnostico NOT NULL,
    Placa_Automovel VARCHAR2(7),
    
    CONSTRAINT Nivel_PreDiagnostico_CHK CHECK (Nivel_Diagnostico >= 1 AND Nivel_Diagnostico <= 100),
    CONSTRAINT FK_PreDiagnostico_Chatbot FOREIGN KEY (Assistente_ID_Chatbot, Cliente_CPF_Cliente) REFERENCES Chatbot(ID_Chatbot, Cliente_CPF_Cliente),
    CONSTRAINT FK_PreDiagnostico_Automovel FOREIGN KEY (Placa_Automovel) REFERENCES Automovel(Placa_Automovel)
);



CREATE TABLE Oficina (
    Endereco_Oficina VARCHAR2(200) CONSTRAINT PK_Oficina PRIMARY KEY,
    Cnpj_Oficina VARCHAR2(18) CONSTRAINT Cnpj_Oficina UNIQUE,
    Nome_Oficina VARCHAR2(120) CONSTRAINT Nome_Oficina NOT NULL,
    Avaliacao_Oficina NUMBER(3, 2),
    Especializacao_Oficina VARCHAR2(50) CONSTRAINT Especializacao_Oficina NOT NULL,
    Chatbot_ID_Chatbot VARCHAR2(1000),
    
    Chatbot_Cliente_CPF_Cliente VARCHAR2(14),
    CONSTRAINT FK_Oficina_Chatbot FOREIGN KEY (Chatbot_ID_Chatbot, Chatbot_Cliente_CPF_Cliente)REFERENCES Chatbot(ID_Chatbot, Cliente_CPF_Cliente),
    CONSTRAINT Cnpj_Oficina_CHK CHECK (REGEXP_LIKE(Cnpj_Oficina, '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}$')),
    CONSTRAINT Avaliacao_Oficina_CHK CHECK (Avaliacao_Oficina BETWEEN 0 AND 10)
);



CREATE TABLE Loja_Parceira (
    Endereco_Loja VARCHAR2(200) CONSTRAINT PK_Loja_Parceira PRIMARY KEY,
    Cnpj_Loja VARCHAR2(18) CONSTRAINT Cnpj_Loja_Parceira UNIQUE,
    Nome_Loja VARCHAR2(120) CONSTRAINT Nome_Loja_Parceira NOT NULL,
    Avaliacao_Loja NUMBER(3, 2),
    
    Especializacao_Loja VARCHAR2(50) CONSTRAINT Especializacao_Loja_Parceira NOT NULL,
    CONSTRAINT Cnpj_Loja_Parceira_CHK CHECK (REGEXP_LIKE(Cnpj_Loja, '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}$')),
    CONSTRAINT Avaliacao_Loja_Parceira_CHK CHECK (Avaliacao_Loja BETWEEN 0 AND 10)
);


CREATE TABLE Peca (
    ID_Peca VARCHAR(10) CONSTRAINT PK_Peca PRIMARY KEY,
    Tipo_Peca VARCHAR2(30) CONSTRAINT Tipo_Peca NOT NULL,
    Nome_Peca VARCHAR2(40) CONSTRAINT Nome_Peca NOT NULL,
    Descricao_peca VARCHAR2(200) CONSTRAINT Descricao_Peca NOT NULL,
    Loja_Parceira_Endereco_Loja VARCHAR2(200),
    
    CONSTRAINT FK_Peca_Loja FOREIGN KEY (Loja_Parceira_Endereco_Loja) REFERENCES Loja_Parceira(Endereco_Loja)
);



CREATE TABLE Entrega (
    ID_Entrega VARCHAR2(100) CONSTRAINT PK_Entrega PRIMARY KEY,
    Data_Entrega DATE CONSTRAINT Data_Entrega NOT NULL,
    Destino_Entrega VARCHAR2(200) CONSTRAINT Destino_Entrega NOT NULL,
    Item_Entrega VARCHAR2(1000) CONSTRAINT Item_Entrega NOT NULL,
    Endereco_Loja VARCHAR2(200) CONSTRAINT Endereco_Entrega NOT NULL,

    CONSTRAINT FK_Entrega_Cliente FOREIGN KEY (Destino_Entrega) REFERENCES Cliente(CPF_Cliente),
    CONSTRAINT FK_Entrega_Peca FOREIGN KEY (Item_Entrega) REFERENCES Peca(ID_Peca),
    CONSTRAINT FK_Entrega_Loja FOREIGN KEY (Endereco_Loja) REFERENCES Loja_Parceira(Endereco_Loja)
);



CREATE TABLE Tabela_de_Associacao (
    CPF_Cliente VARCHAR2(14) CONSTRAINT CPF_Associacao NOT NULL,
    ID_Chatbot VARCHAR2(1000) CONSTRAINT ID_Associacao NOT NULL,
    Endereco_Loja VARCHAR2(200) CONSTRAINT EnderecoLoja_Associacao NOT NULL,
    
    CONSTRAINT PK_Associacao PRIMARY KEY (CPF_Cliente, ID_Chatbot, Endereco_Loja),
    CONSTRAINT FK_Associacao_Chatbot FOREIGN KEY (ID_Chatbot, CPF_Cliente) REFERENCES Chatbot(ID_Chatbot, Cliente_CPF_Cliente),
    CONSTRAINT FK_Associacao_Loja FOREIGN KEY (Endereco_Loja) REFERENCES Loja_Parceira(Endereco_Loja)
);



-------------------------------------------------------------------------------
--2ª Parte: Inserção de Dados nas tabelas

TRUNCATE TABLE Tabela_de_Associacao;
TRUNCATE TABLE Entrega;
TRUNCATE TABLE Peca;
TRUNCATE TABLE Loja_Parceira;
TRUNCATE TABLE Oficina;
TRUNCATE TABLE Pre_Diagnostico;
TRUNCATE TABLE Chatbot;
TRUNCATE TABLE Automovel;
TRUNCATE TABLE Cliente;



INSERT INTO Cliente VALUES ('957.511.398-52', '47639529541', '44.824.287-4', 'Joao', 'Silva', TO_DATE('1985-07-15', 'YYYY-MM-DD'), 'joao.silva@terra.com.br', 'Jo@o1985!', '(11) 98765-4321', 'Rua das Flores, 123, So, Sao Paulo, SP, 01017-911');
INSERT INTO Cliente VALUES ('960.212.777-59', '39854665602', '29.315.292-5', 'Maria', 'Oliveira', TO_DATE('1990-03-22', 'YYYY-MM-DD'), 'maria.oliveira@gmail.com', 'M@ria1990*', '(21) 91234-5678', 'Rua Voluntarios da Patria, 389, Botafogo, Rio de Janeiro, RJ, 22270-901');
INSERT INTO Cliente VALUES ('150.150.618-89', '20475607085', '13.270.512-6', 'Pedro', 'Santos', TO_DATE('1982-05-30', 'YYYY-MM-DD'), 'pedro.santos@hotmail.com', 'P3dr0!S1982', '(11) 99876-5432', 'Rua Dias Leme, 123, Mooca, Sao Paulo, SP, 03118-040');
INSERT INTO Cliente VALUES ('710.615.638-80', '17035943417', '16.087.858-5', 'Ana', 'Costa', TO_DATE('1995-12-10', 'YYYY-MM-DD'), 'ana.costa@gmail.com', 'Ana!1995$', '(11) 98765-6789', 'Avenida Paulista, 1728, Sao Paulo, SP, 01310-919');
INSERT INTO Cliente VALUES ('623.609.139-05', '15941229524', '21.227.544-6', 'Carlos', 'Mendona', TO_DATE('2001-02-18', 'YYYY-MM-DD'), 'carlos.mendonca@cloud.com', 'C@rlos80!', '(41) 99988-7766', 'Rua Antonio Brambilla, 439, Jardim Paris, Maringa, PR, 87083-400');
INSERT INTO Cliente VALUES ('915.453.246-97', '36349804620', '28.938.681-0', 'Fernanda', 'Rodrigues', TO_DATE('2000-04-05', 'YYYY-MM-DD'), 'fernanda.rodrigues@terra.com.br', 'Fern@1993*', '(31) 91234-5678', 'Rua Antonio Marcos da Cruz, 120, Venda Nova, Belo Horizonte, MG, 31570-160');
INSERT INTO Cliente VALUES ('712.226.605-20', '67885379373', '20.668.555-5', 'Marcos', 'Pereira', TO_DATE('1978-11-23', 'YYYY-MM-DD'), 'marcos.pereira@outlook.com', 'M@rcos78!', '(71) 99876-1234', 'Rua Otacilio Santos, 16, Brotas, Salvador, BA, 40285-840');
INSERT INTO Cliente VALUES ('507.902.041-50', '85036538070', '13.678.568-2', 'Beatriz', 'Freitas', TO_DATE('1987-09-12', 'YYYY-MM-DD'), 'beatriz.freitas@outlook.com', 'B3@triz87$', '(61) 99987-6543', 'QR 431 Conjunto 11, 41, Samambaia Norte, Brasilia, DF, 72329-100');
INSERT INTO Cliente VALUES ('121.400.050-90', '21022236880', '44.371.752-7', 'Lucas', 'Souza', TO_DATE('1991-08-30', 'YYYY-MM-DD'), 'lucas.souza@yahoo.com', 'Luc@s1991!', '(51) 99876-7890', 'Rua Antonio Spolidoro, 49, Hipica, Porto Alegre, RS, 91755-018');
INSERT INTO Cliente VALUES ('586.162.931-59', '09856883305', '38.521.524-1', 'Juliana', 'Almeida', TO_DATE('1989-06-14', 'YYYY-MM-DD'), 'juliana.almeida@gmail.com', 'Jul!@1989', '(62) 91234-9876', 'Avenida Presidente Dutra, 24, Jardim Presidente, Goiania, GO, 74353-120');
INSERT INTO Cliente VALUES ('320.609.174-91', '74569385742', '17.093.251-3', 'Renato', 'Lima', TO_DATE('1984-01-25', 'YYYY-MM-DD'), 'renato.lima@hotmail.com', 'R3n@to1984', '(27) 99871-2345', 'Rua da Graciosa, 150, Praia do Canto, Vitoria, ES, 29055-200');
INSERT INTO Cliente VALUES ('205.410.993-67', '55234687901', '22.487.212-0', 'Patricia', 'Ferreira', TO_DATE('1993-07-11', 'YYYY-MM-DD'), 'patricia.ferreira@gmail.com', 'P@tricia93*', '(48) 91234-1234', 'Rua das Palmeiras, 678, Centro, Florianopolis, SC, 88010-001');
INSERT INTO Cliente VALUES ('654.123.785-62', '89236547021', '39.124.658-5', 'Rafael', 'Gomes', TO_DATE('1995-09-09', 'YYYY-MM-DD'), 'rafael.gomes@icloud.com', 'R@fG95!', '(82) 98712-6543', 'Avenida Governador Lamenha Filho, 900, Ponta Verde, Maceio, AL, 57035-350');
INSERT INTO Cliente VALUES ('821.456.984-30', '74125896302', '27.563.289-1', 'Claudia', 'Vieira', TO_DATE('1992-04-03', 'YYYY-MM-DD'), 'claudia.vieira@gmail.com', 'Cl@udia92!', '(85) 99865-3214', 'Rua dos Passaros, 234, Aldeota, Fortaleza, CE, 60160-230');
INSERT INTO Cliente VALUES ('987.654.321-00', '36548721036', '19.287.654-7', 'Bruno', 'Azevedo', TO_DATE('1987-11-17', 'YYYY-MM-DD'), 'bruno.azevedo@yahoo.com', 'Brun0@1987', '(63) 91234-5432', 'Rua 103, 45, Plano Diretor Sul, Palmas, TO, 77020-072');
INSERT INTO Cliente VALUES ('542.896.731-10', '45217896321', '28.654.198-0', 'Simone', 'Martins', TO_DATE('1986-08-22', 'YYYY-MM-DD'), 'simone.martins@terra.com.br', 'Sim@Mart86*', '(65) 99876-6543', 'Avenida Isaac Povoas, 670, Centro, Cuiaba, MT, 78005-340');
INSERT INTO Cliente VALUES ('789.654.321-01', '74196325841', '13.789.654-2', 'Leonardo', 'Pinto', TO_DATE('1985-12-15', 'YYYY-MM-DD'), 'leonardo.pinto@hotmail.com', 'LeoP!nto85', '(24) 98712-3456', 'Rua Dom Pedro II, 12, Bingen, Petropolis, RJ, 25665-091');
INSERT INTO Cliente VALUES ('452.896.123-44', '36542187954', '44.123.658-0', 'Tatiana', 'Carvalho', TO_DATE('1990-02-27', 'YYYY-MM-DD'), 'tatiana.carvalho@icloud.com', 'T@tiana90*', '(98) 99876-4567', 'Rua Grande, 55, Centro, Sao Luis, MA, 65020-240');
INSERT INTO Cliente VALUES ('210.123.456-78', '65789321457', '12.123.789-3', 'Daniel', 'Castro', TO_DATE('1998-10-30', 'YYYY-MM-DD'), 'daniel.castro@outlook.com', 'D@niel98*', '(47) 98765-4321', 'Rua Otto Boehm, 89, Centro, Joinville, SC, 89201-702');
INSERT INTO Cliente VALUES ('346.789.231-10', '52143698721', '11.654.329-5', 'Eduarda', 'Ribeiro', TO_DATE('1994-03-19', 'YYYY-MM-DD'), 'eduarda.ribeiro@terra.com.br', 'Edu@rda94!', '(84) 99876-2345', 'Rua Mossoro, 99, Tirol, Natal, RN, 59020-800');



INSERT INTO Automovel VALUES ('BPR7953', 'Toyota', 'Corolla', 2018, '957.511.398-52');
INSERT INTO Automovel VALUES ('VTA7953', 'Ford', 'Fiesta', 2010, '957.511.398-52');
INSERT INTO Automovel VALUES ('LGE5785', 'Honda', 'Civic', 2020, '960.212.777-59');
INSERT INTO Automovel VALUES ('EBL9191', 'Ford', 'Fusion', 2017, '150.150.618-89');
INSERT INTO Automovel VALUES ('DQF2104', 'Chevrolet', 'Onix', 2019, '710.615.638-80');
INSERT INTO Automovel VALUES ('BEO6906', 'Volkswagen', 'Golf', 2021, '623.609.139-05');
INSERT INTO Automovel VALUES ('GZV0060', 'Renault', 'Duster', 2015, '915.453.246-97');
INSERT INTO Automovel VALUES ('JRX2968', 'Hyundai', 'Creta', 2020, '712.226.605-20');
INSERT INTO Automovel VALUES ('JGA2190', 'Jeep', 'Renegade', 2018, '507.902.041-50');
INSERT INTO Automovel VALUES ('ILI9692', 'Peugeot', '208', 2021, '121.400.050-90');
INSERT INTO Automovel VALUES ('KDK2311', 'Fiat', 'Cronos', 2019, '586.162.931-59');
INSERT INTO Automovel VALUES ('MTX7531', 'Nissan', 'Sentra', 2018, '320.609.174-91');
INSERT INTO Automovel VALUES ('POF8742', 'Hyundai', 'HB20', 2019, '205.410.993-67');
INSERT INTO Automovel VALUES ('LGK6574', 'Chevrolet', 'Prisma', 2020, '654.123.785-62');
INSERT INTO Automovel VALUES ('GFD2431', 'Toyota', 'Hilux', 2017, '821.456.984-30');
INSERT INTO Automovel VALUES ('HXP5642', 'Honda', 'Fit', 2016, '987.654.321-00');
INSERT INTO Automovel VALUES ('TRD8890', 'Volkswagen', 'Polo', 2021, '542.896.731-10');
INSERT INTO Automovel VALUES ('CPQ3402', 'Renault', 'Captur', 2020, '789.654.321-01');
INSERT INTO Automovel VALUES ('MXD5491', 'Fiat', 'Mobi', 2019, '452.896.123-44');
INSERT INTO Automovel VALUES ('UHB2987', 'Ford', 'EcoSport', 2018, '210.123.456-78');
INSERT INTO Automovel VALUES ('IVL6583', 'Jeep', 'Compass', 2021, '346.789.231-10');
INSERT INTO Automovel VALUES ('LMN2B34', 'Fiat', 'Palio', 2018, '957.511.398-52');       
INSERT INTO Automovel VALUES ('OPQ3C45', 'Chevrolet', 'Onix', 2021, '623.609.139-05');
INSERT INTO Automovel VALUES ('RST4D56', 'Hyundai', 'HB20', 2019, '121.400.050-90'); 
INSERT INTO Automovel VALUES ('UVW5E67', 'Ford', 'Ka', 2021, '987.654.321-00');         
INSERT INTO Automovel VALUES ('JKL6F78', 'Renault', 'Sandero', 2020, '210.123.456-78'); 
INSERT INTO Automovel VALUES ('MNO7G89', 'Nissan', 'Kicks', 2021, '789.654.321-01');     
INSERT INTO Automovel VALUES ('QRS8H90', 'Toyota', 'Yaris', 2020, '654.123.785-62');    
INSERT INTO Automovel VALUES ('TUV9I01', 'Honda', 'Fit', 2019, '452.896.123-44');       
INSERT INTO Automovel VALUES ('WXY0J12', 'Citroën', 'C3', 2020, '320.609.174-91');       



INSERT INTO Chatbot VALUES ('CHAT#0001', DATE '2024-04-20', 'Basico', '957.511.398-52', 'BPR7953');
INSERT INTO Chatbot VALUES ('CHAT#0002', DATE '2024-05-15', 'Premium', '960.212.777-59', 'LGE5785');
INSERT INTO Chatbot VALUES ('CHAT#0003', DATE '2024-06-10', 'Basico', '150.150.618-89', 'EBL9191');
INSERT INTO Chatbot VALUES ('CHAT#0004', DATE '2024-07-01', 'Premium', '710.615.638-80', 'DQF2104');
INSERT INTO Chatbot VALUES ('CHAT#0005', DATE '2024-08-18', 'Basico', '623.609.139-05', 'BEO6906');
INSERT INTO Chatbot VALUES ('CHAT#0006', DATE '2024-09-05', 'Premium', '915.453.246-97', 'GZV0060');
INSERT INTO Chatbot VALUES ('CHAT#0007', DATE '2024-09-20', 'Basico', '712.226.605-20', 'JRX2968');
INSERT INTO Chatbot VALUES ('CHAT#0008', DATE '2024-10-02', 'Premium', '507.902.041-50', 'JGA2190');
INSERT INTO Chatbot VALUES ('CHAT#0009', DATE '2024-10-15', 'Basico', '121.400.050-90', 'ILI9692');
INSERT INTO Chatbot VALUES ('CHAT#0010', DATE '2024-10-22', 'Premium', '586.162.931-59', 'KDK2311');
INSERT INTO Chatbot VALUES ('CHAT#0011', DATE '2024-10-25', 'Basico', '320.609.174-91', 'MTX7531');
INSERT INTO Chatbot VALUES ('CHAT#0012', DATE '2024-10-28', 'Premium', '205.410.993-67', 'POF8742');
INSERT INTO Chatbot VALUES ('CHAT#0013', DATE '2024-10-29', 'Basico', '654.123.785-62', 'LGK6574');
INSERT INTO Chatbot VALUES ('CHAT#0014', DATE '2024-10-30', 'Premium', '821.456.984-30', 'GFD2431');
INSERT INTO Chatbot VALUES ('CHAT#0015', DATE '2024-10-31', 'Basico', '987.654.321-00', 'HXP5642');
INSERT INTO Chatbot VALUES ('CHAT#0016', DATE '2024-11-01', 'Premium', '542.896.731-10', 'TRD8890');
INSERT INTO Chatbot VALUES ('CHAT#0017', DATE '2024-11-02', 'Basico', '789.654.321-01', 'CPQ3402');
INSERT INTO Chatbot VALUES ('CHAT#0018', DATE '2024-11-02', 'Premium', '452.896.123-44', 'MXD5491');
INSERT INTO Chatbot VALUES ('CHAT#0019', DATE '2024-11-03', 'Basico', '210.123.456-78', 'UHB2987');
INSERT INTO Chatbot VALUES ('CHAT#0020', DATE '2024-11-03', 'Premium', '346.789.231-10', 'IVL6583');




INSERT INTO Pre_Diagnostico VALUES ('PD#0001', 85, 'Problema no Freio', 'CHAT#0001', '957.511.398-52', 'BPR7953');
INSERT INTO Pre_Diagnostico VALUES ('PD#0002', 60, 'Problema no Motor', 'CHAT#0002', '960.212.777-59', 'LGE5785');
INSERT INTO Pre_Diagnostico VALUES ('PD#0003', 75, 'Problema na Suspensao', 'CHAT#0003', '150.150.618-89', 'EBL9191');
INSERT INTO Pre_Diagnostico VALUES ('PD#0004', 40, 'Problema na Direcao', 'CHAT#0004', '710.615.638-80', 'DQF2104');
INSERT INTO Pre_Diagnostico VALUES ('PD#0005', 55, 'Problema na Direcao', 'CHAT#0005', '623.609.139-05', 'BEO6906');
INSERT INTO Pre_Diagnostico VALUES ('PD#0006', 90, 'Problema no Sistema Eletrico', 'CHAT#0006', '915.453.246-97', 'GZV0060');
INSERT INTO Pre_Diagnostico VALUES ('PD#0007', 65, 'Problema no Motor', 'CHAT#0007', '712.226.605-20', 'JRX2968');
INSERT INTO Pre_Diagnostico VALUES ('PD#0008', 50, 'Problema nos Pneus', 'CHAT#0008', '507.902.041-50', 'JGA2190');
INSERT INTO Pre_Diagnostico VALUES ('PD#0009', 78, 'Problema na Suspensao', 'CHAT#0009', '121.400.050-90', 'ILI9692');
INSERT INTO Pre_Diagnostico VALUES ('PD#0010', 70, 'Problema no Sistema Eletrico', 'CHAT#0010', '586.162.931-59', 'KDK2311');
INSERT INTO Pre_Diagnostico VALUES ('PD#0011', 60, 'Problema no Conforto', 'CHAT#0011', '320.609.174-91', 'MTX7531');
INSERT INTO Pre_Diagnostico VALUES ('PD#0012', 82, 'Problema no Freio', 'CHAT#0012', '205.410.993-67', 'POF8742');
INSERT INTO Pre_Diagnostico VALUES ('PD#0013', 76, 'Problema no Conforto', 'CHAT#0013', '654.123.785-62', 'LGK6574');
INSERT INTO Pre_Diagnostico VALUES ('PD#0014', 85, 'Problema na Direcao', 'CHAT#0014', '821.456.984-30', 'GFD2431');
INSERT INTO Pre_Diagnostico VALUES ('PD#0015', 92, 'Problema no Sistema Eletrico', 'CHAT#0015', '987.654.321-00', 'HXP5642');
INSERT INTO Pre_Diagnostico VALUES ('PD#0016', 58, 'Problema no Freio', 'CHAT#0016', '542.896.731-10', 'TRD8890');
INSERT INTO Pre_Diagnostico VALUES ('PD#0017', 67, 'Problema na Direcao', 'CHAT#0017', '789.654.321-01', 'CPQ3402');
INSERT INTO Pre_Diagnostico VALUES ('PD#0018', 64, 'Problema na Suspensao', 'CHAT#0018', '452.896.123-44', 'MXD5491');
INSERT INTO Pre_Diagnostico VALUES ('PD#0019', 73, 'Problema nos Pneus', 'CHAT#0019', '210.123.456-78', 'UHB2987');
INSERT INTO Pre_Diagnostico VALUES ('PD#0020', 50, 'Problema no sistema de seguranca', 'CHAT#0020', '346.789.231-10', 'IVL6583');



INSERT INTO Oficina VALUES ('Rua das Laranjeiras, 100, Centro, Sao Paulo, SP, 01234-000', '69.907.785/0412-90', 'Oficina Laranjeiras', 8.5, 'Mecanica Geral', 'CHAT#0001', '957.511.398-52');
INSERT INTO Oficina VALUES ('Avenida Rio Branco, 200, Centro, Belo Horizonte, MG, 30123-000', '34.727.651/2767-82', 'Oficina Rio Branco', 9.0, 'Direcao', 'CHAT#0002', '960.212.777-59');
INSERT INTO Oficina VALUES ('Rua do Comercio, 150, Centro, Curitiba, PR, 80010-200', '78.798.692/8646-70', 'Oficina Comercio', 7.8, 'Freios', 'CHAT#0003', '150.150.618-89');
INSERT INTO Oficina VALUES ('Avenida das Nacoes, 300, Centro, Rio de Janeiro, RJ, 20010-300', '45.591.610/4708-85', 'Oficina Nacoes', 8.3, 'Suspensao', 'CHAT#0004', '710.615.638-80');
INSERT INTO Oficina VALUES ('Rua do Sol, 400, Jardim America, Sao Paulo, SP, 01430-400', '04.170.584/8752-22', 'Oficina Sol', 8.0, 'Conforto', 'CHAT#0005', '623.609.139-05');
INSERT INTO Oficina VALUES ('Avenida Sao Paulo, 450, Vila Mariana, Sao Paulo, SP, 04110-500', '04.523.324/6933-49', 'Oficina Sao Paulo', 9.2, 'Mecanica Geral', 'CHAT#0006', '915.453.246-97');
INSERT INTO Oficina VALUES ('Rua Amazonas, 500, Centro, Porto Alegre, RS, 90050-600', '24.275.492/0071-07', 'Oficina Amazonas', 8.1, 'Pneus', 'CHAT#0007', '712.226.605-20');
INSERT INTO Oficina VALUES ('Rua da Luz, 600, Liberdade, Sao Paulo, SP, 01502-700', '11.012.220/0969-14', 'Oficina Luz', 8.7, 'Sistema Eletrico', 'CHAT#0008', '507.902.041-50');
INSERT INTO Oficina VALUES ('Avenida Independencia, 700, Centro, Salvador, BA, 40080-800', '25.220.325/8473-75', 'Oficina Independencia', 9.3, 'Direcao', 'CHAT#0009', '121.400.050-90');
INSERT INTO Oficina VALUES ('Rua das Pedras, 800, Centro, Recife, PE, 50030-900', '82.404.368/3549-09', 'Oficina Pedras', 7.5, 'Mecanica Geral', 'CHAT#0010', '586.162.931-59');
INSERT INTO Oficina VALUES ('Avenida Joao Paulo, 900, Centro, Brasilia, DF, 70010-000', '82.147.975/3458-69', 'Oficina Joao Paulo', 7.9, 'Freios', 'CHAT#0011', '320.609.174-91');
INSERT INTO Oficina VALUES ('Rua da Republica, 1000, Centro, Fortaleza, CE, 60010-100', '81.087.250/9277-29', 'Oficina Republica', 8.6, 'Suspensao', 'CHAT#0012', '205.410.993-67');
INSERT INTO Oficina VALUES ('Rua do Mercado, 1100, Centro, Natal, RN, 59010-200', '45.387.578/6325-78', 'Oficina Mercado', 8.8, 'Sistema Eletrico', 'CHAT#0013', '654.123.785-62');
INSERT INTO Oficina VALUES ('Avenida Sao Jorge, 1200, Centro, Goiania, GO, 74010-300', '24.928.009/9701-67', 'Oficina Sao Jorge', 8.4, 'Conforto', 'CHAT#0014', '821.456.984-30');
INSERT INTO Oficina VALUES ('Rua da Esperanca, 1300, Centro, Florianopolis, SC, 88010-400', '34.624.696/5976-09', 'Oficina Esperanca', 8.2, 'Mecanica Geral', 'CHAT#0015', '987.654.321-00');
INSERT INTO Oficina VALUES ('Avenida das Americas, 1400, Centro, Sao Luis, MA, 65010-500', '33.540.609/5549-49', 'Oficina Americas', 9.1, 'Direcao', 'CHAT#0016', '542.896.731-10');
INSERT INTO Oficina VALUES ('Rua das Criancas, 1500, Centro, Vitoria, ES, 29010-600', '40.514.028/6076-00', 'Oficina Criancas', 8.0, 'Pneus', 'CHAT#0017', '789.654.321-01');
INSERT INTO Oficina VALUES ('Avenida da Liberdade, 1600, Centro, Belem, PA, 66010-700', '62.877.814/6601-74', 'Oficina Liberdade', 8.9, 'Freios', 'CHAT#0018', '452.896.123-44');
INSERT INTO Oficina VALUES ('Rua do Progresso, 1700, Centro, Teresina, PI, 64010-800', '67.439.033/7632-71', 'Oficina Progresso', 9.4, 'Suspensao', 'CHAT#0019', '210.123.456-78');
INSERT INTO Oficina VALUES ('Rua da Vitoria, 1800, Centro, Campo Grande, MS, 79010-900', '15.836.086/2889-15', 'Oficina Vitoria', 8.1, 'Sistema Eletrico', 'CHAT#0020', '346.789.231-10');



INSERT INTO Loja_Parceira VALUES ('Rua das Flores, 123, Centro, Sao Paulo, SP, 01001-000', '56.937.785/0001-88', 'Auto Mecanica Flores', 8.5, 'Mecanica Geral');
INSERT INTO Loja_Parceira VALUES ('Avenida Brasil, 500, Santa Efigenia, Belo Horizonte, MG, 30120-100', '71.651.595/0001-93', 'BH Suspensao', 9.0, 'Suspensao e Direcao');
INSERT INTO Loja_Parceira VALUES ('Rua do Comercio, 111, Centro, Curitiba, PR, 80010-120', '39.581.015/0001-26', 'Oficina Motor Show', 7.8, 'Mecanica Geral');
INSERT INTO Loja_Parceira VALUES ('Avenida dos Estados, 2020, Industrial, Santo Andre, SP, 09210-580', '65.231.239/0001-18', 'Freios Andre', 8.3, 'Freios');
INSERT INTO Loja_Parceira VALUES ('Rua Rio Branco, 56, Centro, Recife, PE, 50010-050', '04.794.532/0001-07', 'Recife Pneus', 8.0, 'Pneus');
INSERT INTO Loja_Parceira VALUES ('Avenida Goias, 150, Setor Oeste, Goiania, GO, 74000-120', '43.992.832/0001-44', 'Goiana Eletrica', 9.2, 'Sistema Eletrico');
INSERT INTO Loja_Parceira VALUES ('Rua XV de Novembro, 77, Centro, Joinville, SC, 89201-580', '71.837.516/0001-33', 'Joinville Motors', 8.1, 'Direcao');
INSERT INTO Loja_Parceira VALUES ('Rua Boa Vista, 204, Bela Vista, Porto Alegre, RS, 90030-600', '42.533.787/0001-05', 'Auto Sul', 8.7, 'Mecanica Geral');
INSERT INTO Loja_Parceira VALUES ('Avenida Paulista, 1000, Bela Vista, Sao Paulo, SP, 01310-100', '57.247.157/0001-33', 'Paulista Autocenter', 9.3, 'Suspensao e Direcao');
INSERT INTO Loja_Parceira VALUES ('Rua Sete de Setembro, 309, Centro, Rio de Janeiro, RJ, 20050-009', '54.745.487/0001-60', 'RJ Car Service', 7.5, 'Conforto');
INSERT INTO Loja_Parceira VALUES ('Rua Bahia, 405, Ponta Verde, Maceio, AL, 57035-170', '41.707.427/0001-01', 'Maceio Auto Center', 7.9, 'Pneus');
INSERT INTO Loja_Parceira VALUES ('Avenida Amazonas, 2150, Prado, Belo Horizonte, MG, 30411-089', '82.603.225/0001-05', 'BH Automotiva', 8.6, 'Motor');
INSERT INTO Loja_Parceira VALUES ('Rua das Oliveiras, 256, Morumbi, Sao Paulo, SP, 05605-050', '73.045.574/0001-50', 'Sao Paulo Off Road', 8.8, 'Suspensao');
INSERT INTO Loja_Parceira VALUES ('Avenida Visconde, 111, Aldeota, Fortaleza, CE, 60110-200', '77.116.203/0001-72', 'Fortaleza Direcao', 8.4, 'Direcao');
INSERT INTO Loja_Parceira VALUES ('Rua Sao Jose, 310, Vila Matilde, Sao Paulo, SP, 03530-000', '33.574.330/0001-40', 'Auto Servicos Matilde', 8.2, 'Freios');
INSERT INTO Loja_Parceira VALUES ('Rua Paraiso, 80, Centro, Campinas, SP, 13010-120', '23.462.016/0001-11', 'Campinas Eletronica', 9.1, 'Sistema Eletrico');
INSERT INTO Loja_Parceira VALUES ('Rua do Sol, 132, Centro, Teresina, PI, 64000-090', '48.517.413/0001-74', 'Auto Mecanica Teresina', 8.0, 'Conforto');
INSERT INTO Loja_Parceira VALUES ('Avenida Tamoios, 58, Jardim America, Sao Paulo, SP, 01407-000', '05.385.190/0001-26', 'Tamoios Auto Parts', 8.9, 'Mecanica Geral');
INSERT INTO Loja_Parceira VALUES ('Rua das Palmeiras, 456, Boa Vista, Curitiba, PR, 80510-010', '99.634.920/0001-29', 'Curitiba Suspensao', 8.5, 'Suspensao e Direcao');
INSERT INTO Loja_Parceira VALUES ('Avenida Central, 900, Centro, Salvador, BA, 40020-000', '01.345.678/0001-20', 'Salvador Auto Center', 8.4, 'Freios');



INSERT INTO Peca VALUES ('PECA#0001', 'Freio', 'Pastilha de Freio', 'Pastilha de Freio para veiculos de passeio, eficiencia em frenagem.', 'Rua das Flores, 123, Centro, Sao Paulo, SP, 01001-000');
INSERT INTO Peca VALUES ('PECA#0002', 'Direcao', 'Bucha de Direcao', 'Bucha de Direcao para manutencao de sistema de Direcao, aumento da seguranca.', 'Avenida Brasil, 500, Santa Efigenia, Belo Horizonte, MG, 30120-100');
INSERT INTO Peca VALUES ('PECA#0003', 'Motor', 'Filtro de oleo', 'Filtro de oleo para Motor, ajuda a manter o Motor limpo e funcionando.', 'Rua do Comercio, 111, Centro, Curitiba, PR, 80010-120');
INSERT INTO Peca VALUES ('PECA#0004', 'Conforto', 'Banco de Couro', 'Banco de couro para veiculos, conforto e estetica.', 'Avenida dos Estados, 2020, Industrial, Santo Andre, SP, 09210-580');
INSERT INTO Peca VALUES ('PECA#0005', 'Pneus', 'Pneu Radial', 'Pneu radial para veiculos de passeio, durabilidade e desempenho.', 'Rua Rio Branco, 56, Centro, Recife, PE, 50010-050');
INSERT INTO Peca VALUES ('PECA#0006', 'Sistema Eletrico', 'Bateria Automotiva', 'Bateria automotiva de alta performance, compativel com diversos veiculos.', 'Avenida Goias, 150, Setor Oeste, Goiania, GO, 74000-120');
INSERT INTO Peca VALUES ('PECA#0007', 'Direcao', 'Embreagem', 'Kit de embreagem para troca em veiculos de passeio.', 'Rua XV de Novembro, 77, Centro, Joinville, SC, 89201-580');
INSERT INTO Peca VALUES ('PECA#0008', 'Suspensao', 'Amortecedor', 'Amortecedor para manutencao da Suspensao do veiculo.', 'Rua Boa Vista, 204, Bela Vista, Porto Alegre, RS, 90030-600');
INSERT INTO Peca VALUES ('PECA#0009', 'Visibilidade', 'Palhetas de Limpador', 'Palhetas de limpador para garantir visibilidade em dias de chuva.', 'Avenida Paulista, 1000, Bela Vista, Sao Paulo, SP, 01310-100');
INSERT INTO Peca VALUES ('PECA#0010', 'Sistema de seguranca', 'Cinto de seguranca', 'Cinto de seguranca de tres pontos, essencial para seguranca dos ocupantes.', 'Rua Sete de Setembro, 309, Centro, Rio de Janeiro, RJ, 20050-009');
INSERT INTO Peca VALUES ('PECA#0011', 'Freio', 'Disco de Freio', 'Disco de Freio de alta performance, para melhor frenagem.', 'Rua Bahia, 405, Ponta Verde, Maceio, AL, 57035-170');
INSERT INTO Peca VALUES ('PECA#0012', 'Direcao', 'Volante', 'Volante com design ergonomica, para maior conforto ao dirigir.', 'Avenida Amazonas, 2150, Prado, Belo Horizonte, MG, 30411-089');
INSERT INTO Peca VALUES ('PECA#0013', 'Motor', 'Velas de Ignicao', 'Velas de Ignicao para Motor, melhor desempenho e economia de Combustivel.', 'Rua das Oliveiras, 256, Morumbi, Sao Paulo, SP, 05605-050');
INSERT INTO Peca VALUES ('PECA#0014', 'Conforto', 'Almofada de Cabeca', 'Almofada de Cabeca para maior conforto em viagens longas.', 'Avenida Visconde, 111, Aldeota, Fortaleza, CE, 60110-200');
INSERT INTO Peca VALUES ('PECA#0015', 'Pneus', 'Pneu de Inverno', 'Pneu de inverno, ideal para condicoes climaticas adversas.', 'Rua Sao Jose, 310, Vila Matilde, Sao Paulo, SP, 03530-000');
INSERT INTO Peca VALUES ('PECA#0016', 'Sistema Eletrico', 'Alternador', 'Alternador de alta eficiencia, essencial para recarga da bateria.', 'Rua Paraiso, 80, Centro, Campinas, SP, 13010-120');
INSERT INTO Peca VALUES ('PECA#0017', 'Direcao', 'Cambio automatico', 'Cambio automatico para suavizar a troca de marchas.', 'Rua do Sol, 132, Centro, Teresina, PI, 64000-090');
INSERT INTO Peca VALUES ('PECA#0018', 'Suspensao', 'Molde da Suspensao', 'Mola da Suspensao, garante conforto e estabilidade ao dirigir.', 'Avenida Tamoios, 58, Jardim America, Sao Paulo, SP, 01407-000');
INSERT INTO Peca VALUES ('PECA#0019', 'Visibilidade', 'Farol', 'Farol automotivo, essencial para seguranca a noite.', 'Rua das Palmeiras, 456, Boa Vista, Curitiba, PR, 80510-010');
INSERT INTO Peca VALUES ('PECA#0020', 'Sistema de seguranca', 'Trava de seguranca', 'Trava de seguranca para portas, aumenta a protecao do veiculo.', 'Avenida Central, 900, Centro, Salvador, BA, 40020-000');



INSERT INTO Entrega VALUES ('ENTREGA#0001', TO_DATE('2024-04-10', 'YYYY-MM-DD'), '957.511.398-52', 'PECA#0001', 'Rua das Flores, 123, Centro, Sao Paulo, SP, 01001-000');
INSERT INTO Entrega VALUES ('ENTREGA#0002', TO_DATE('2024-05-15', 'YYYY-MM-DD'), '960.212.777-59', 'PECA#0002', 'Avenida Brasil, 500, Santa Efigenia, Belo Horizonte, MG, 30120-100');
INSERT INTO Entrega VALUES ('ENTREGA#0003', TO_DATE('2024-06-20', 'YYYY-MM-DD'), '150.150.618-89', 'PECA#0003', 'Rua do Comercio, 111, Centro, Curitiba, PR, 80010-120');
INSERT INTO Entrega VALUES ('ENTREGA#0004', TO_DATE('2024-07-25', 'YYYY-MM-DD'), '710.615.638-80', 'PECA#0004', 'Avenida dos Estados, 2020, Industrial, Santo Andre, SP, 09210-580');
INSERT INTO Entrega VALUES ('ENTREGA#0005', TO_DATE('2024-09-01', 'YYYY-MM-DD'), '623.609.139-05', 'PECA#0005', 'Rua Rio Branco, 56, Centro, Recife, PE, 50010-050');
INSERT INTO Entrega VALUES ('ENTREGA#0006', TO_DATE('2024-09-06', 'YYYY-MM-DD'), '915.453.246-97', 'PECA#0006', 'Avenida Goias, 150, Setor Oeste, Goiania, GO, 74000-120');
INSERT INTO Entrega VALUES ('ENTREGA#0007', TO_DATE('2024-09-11', 'YYYY-MM-DD'), '712.226.605-20', 'PECA#0007', 'Rua XV de Novembro, 77, Centro, Joinville, SC, 89201-580');
INSERT INTO Entrega VALUES ('ENTREGA#0008', TO_DATE('2024-09-18', 'YYYY-MM-DD'), '507.902.041-50', 'PECA#0008', 'Rua Boa Vista, 204, Bela Vista, Porto Alegre, RS, 90030-600');
INSERT INTO Entrega VALUES ('ENTREGA#0009', TO_DATE('2024-09-25', 'YYYY-MM-DD'), '121.400.050-90', 'PECA#0009', 'Avenida Paulista, 1000, Bela Vista, Sao Paulo, SP, 01310-100');
INSERT INTO Entrega VALUES ('ENTREGA#0010', TO_DATE('2024-09-29', 'YYYY-MM-DD'), '586.162.931-59', 'PECA#0010', 'Rua Sete de Setembro, 309, Centro, Rio de Janeiro, RJ, 20050-009');
INSERT INTO Entrega VALUES ('ENTREGA#0011', TO_DATE('2024-10-09', 'YYYY-MM-DD'), '320.609.174-91', 'PECA#0011', 'Rua Bahia, 405, Ponta Verde, Maceio, AL, 57035-170');
INSERT INTO Entrega VALUES ('ENTREGA#0012', TO_DATE('2024-10-08', 'YYYY-MM-DD'), '205.410.993-67', 'PECA#0012', 'Avenida Amazonas, 2150, Prado, Belo Horizonte, MG, 30411-089');
INSERT INTO Entrega VALUES ('ENTREGA#0013', TO_DATE('2024-10-13', 'YYYY-MM-DD'), '654.123.785-62', 'PECA#0013', 'Rua das Oliveiras, 256, Morumbi, Sao Paulo, SP, 05605-050');
INSERT INTO Entrega VALUES ('ENTREGA#0014', TO_DATE('2024-10-17', 'YYYY-MM-DD'), '821.456.984-30', 'PECA#0014', 'Avenida Visconde, 111, Aldeota, Fortaleza, CE, 60110-200');
INSERT INTO Entrega VALUES ('ENTREGA#0015', TO_DATE('2024-10-21', 'YYYY-MM-DD'), '987.654.321-00', 'PECA#0015', 'Rua Sao Jose, 310, Vila Matilde, Sao Paulo, SP, 03530-000');
INSERT INTO Entrega VALUES ('ENTREGA#0016', TO_DATE('2024-10-26', 'YYYY-MM-DD'), '542.896.731-10', 'PECA#0016', 'Rua Paraiso, 80, Centro, Campinas, SP, 13010-120');
INSERT INTO Entrega VALUES ('ENTREGA#0017', TO_DATE('2024-11-02', 'YYYY-MM-DD'), '789.654.321-01', 'PECA#0017', 'Rua do Sol, 132, Centro, Teresina, PI, 64000-090');
INSERT INTO Entrega VALUES ('ENTREGA#0018', TO_DATE('2024-11-03', 'YYYY-MM-DD'), '452.896.123-44', 'PECA#0018', 'Avenida Tamoios, 58, Jardim America, Sao Paulo, SP, 01407-000');
INSERT INTO Entrega VALUES ('ENTREGA#0019', TO_DATE('2024-11-04', 'YYYY-MM-DD'), '210.123.456-78', 'PECA#0019', 'Rua das Palmeiras, 456, Boa Vista, Curitiba, PR, 80510-010');
INSERT INTO Entrega VALUES ('ENTREGA#0020', TO_DATE('2024-11-04', 'YYYY-MM-DD'), '346.789.231-10', 'PECA#0020', 'Avenida Central, 900, Centro, Salvador, BA, 40020-000');




INSERT INTO Tabela_de_Associacao VALUES ('957.511.398-52', 'CHAT#0001', 'Rua das Flores, 123, Centro, Sao Paulo, SP, 01001-000');
INSERT INTO Tabela_de_Associacao VALUES ('960.212.777-59', 'CHAT#0002', 'Avenida Brasil, 500, Santa Efigenia, Belo Horizonte, MG, 30120-100');
INSERT INTO Tabela_de_Associacao VALUES ('150.150.618-89', 'CHAT#0003', 'Rua do Comercio, 111, Centro, Curitiba, PR, 80010-120');
INSERT INTO Tabela_de_Associacao VALUES ('710.615.638-80', 'CHAT#0004', 'Avenida dos Estados, 2020, Industrial, Santo Andre, SP, 09210-580');
INSERT INTO Tabela_de_Associacao VALUES ('623.609.139-05', 'CHAT#0005', 'Rua Rio Branco, 56, Centro, Recife, PE, 50010-050');
INSERT INTO Tabela_de_Associacao VALUES ('915.453.246-97', 'CHAT#0006', 'Avenida Goias, 150, Setor Oeste, Goiania, GO, 74000-120');
INSERT INTO Tabela_de_Associacao VALUES ('712.226.605-20', 'CHAT#0007', 'Rua XV de Novembro, 77, Centro, Joinville, SC, 89201-580');
INSERT INTO Tabela_de_Associacao VALUES ('507.902.041-50', 'CHAT#0008', 'Rua Boa Vista, 204, Bela Vista, Porto Alegre, RS, 90030-600');
INSERT INTO Tabela_de_Associacao VALUES ('121.400.050-90', 'CHAT#0009', 'Avenida Paulista, 1000, Bela Vista, Sao Paulo, SP, 01310-100');
INSERT INTO Tabela_de_Associacao VALUES ('586.162.931-59', 'CHAT#0010', 'Rua Sete de Setembro, 309, Centro, Rio de Janeiro, RJ, 20050-009');
INSERT INTO Tabela_de_Associacao VALUES ('320.609.174-91', 'CHAT#0011', 'Rua Bahia, 405, Ponta Verde, Maceio, AL, 57035-170');
INSERT INTO Tabela_de_Associacao VALUES ('205.410.993-67', 'CHAT#0012', 'Avenida Amazonas, 2150, Prado, Belo Horizonte, MG, 30411-089');
INSERT INTO Tabela_de_Associacao VALUES ('654.123.785-62', 'CHAT#0013', 'Rua das Oliveiras, 256, Morumbi, Sao Paulo, SP, 05605-050');
INSERT INTO Tabela_de_Associacao VALUES ('821.456.984-30', 'CHAT#0014', 'Avenida Visconde, 111, Aldeota, Fortaleza, CE, 60110-200');
INSERT INTO Tabela_de_Associacao VALUES ('987.654.321-00', 'CHAT#0015', 'Rua Sao Jose, 310, Vila Matilde, Sao Paulo, SP, 03530-000');
INSERT INTO Tabela_de_Associacao VALUES ('542.896.731-10', 'CHAT#0016', 'Rua Paraiso, 80, Centro, Campinas, SP, 13010-120');
INSERT INTO Tabela_de_Associacao VALUES ('789.654.321-01', 'CHAT#0017', 'Rua do Sol, 132, Centro, Teresina, PI, 64000-090');
INSERT INTO Tabela_de_Associacao VALUES ('452.896.123-44', 'CHAT#0018', 'Avenida Tamoios, 58, Jardim America, Sao Paulo, SP, 01407-000');
INSERT INTO Tabela_de_Associacao VALUES ('210.123.456-78', 'CHAT#0019', 'Rua das Palmeiras, 456, Boa Vista, Curitiba, PR, 80510-010');
INSERT INTO Tabela_de_Associacao VALUES ('346.789.231-10', 'CHAT#0020', 'Avenida Central, 900, Centro, Salvador, BA, 40020-000');

COMMIT;

SELECT * FROM Cliente;
SELECT * FROM Automovel;
SELECT * FROM Chatbot;
SELECT * FROM Pre_Diagnostico;
SELECT * FROM Oficina;
SELECT * FROM Loja_Parceira;
SELECT * FROM Peca;
SELECT * FROM Entrega;
SELECT * FROM Tabela_de_Associacao;

-------------------------------------------------------------------------------
-- 3ªParte: Criação dos Relatórios

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


