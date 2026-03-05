
---

# Diagnoscar

### Integrantes:
- **João Gabriel Boaventura Marques e Silva** | RM: 554874
- **Lucas de Melo Pinheiro Pinho** | RM: 558791
- **Lucas Leal das Chagas** | RM: 551124

### Instalações Necessárias
Para navegar entre diferentes páginas no projeto, será necessário instalar o React Router DOM. Siga os passos abaixo:

1. Abra o terminal na pasta do projeto **Diagnoscar**.
2. Execute o comando:
   ```bash
   npm install
   ```
   Aguarde a conclusão do download das dependências.

3. Em seguida, instale o React Router DOM com o comando:
   ```bash
   npm install react-router-dom
   ```
   Novamente, aguarde até o término do processo de instalação.

4. Em seguida, instale o Input Mask com o comando:
   ```bash
   npm install react-input-mask --save
   ```
   Novamente, aguarde até o término do processo de instalação.

5. Em seguida, instale o react-leaflet com o comando:
   ```bash
   npm install leaflet react-leaflet
   ```
   Aguarde até o término do processo de instalação e logo em seguida instale:
      ```bash
   npm install @types/leaflet
   ```
6. E por último, instale o Input Mask com o comando:
   ```bash
   npm install --save-dev http-proxy-middleware
   ```

6. Após tudo instalado, dê um "Run As --> Run on Server" o 'diagnoscarweb' no Eclipse IDE com o 'Tomcat V9.0 Server', e depois de rodado em server crie as tabelas no Oracle SQL Developer usando o arquivo DiagnosCAR.sql

```bash
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
```

### Demonstração
Confira a demonstração em vídeo no YouTube através do link abaixo:

[**Link para o vídeo de demonstração no YouTube**](https://youtu.be/rzC4lISP7Jo)

### Caso de algum problema
Link Google Drive (Backup): [**Link Google Drive**](https://drive.google.com/drive/folders/1fOA1DFnIBCm7X4X5p-MeAOfecm5RT8Ze?usp=drive_link)

Link GIHUB(Repositório): [**Link GITHUB**](https://github.com/thejaobiell/sprint4-frontend)

---
