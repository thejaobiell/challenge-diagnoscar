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