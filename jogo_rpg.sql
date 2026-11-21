/* ============================================================
   PROJETO: Banco de Dados - Jogo de RPG Online
   ATIVIDADE: Criar as tabelas utilizando Linguagem de
              Definição de Dados (DDL)
   SGBD: Microsoft SQL Server
   AUTOR: Edson Silva
   ------------------------------------------------------------
   Entidades:  USUARIOS, PERSONAGENS, CLASSES, HABILIDADES,
               CLASSES_HABILIDADES (tabela associativa)
   Relacionamentos:
     - USUARIOS 1:N PERSONAGENS
     - CLASSES  1:N PERSONAGENS
     - CLASSES  N:N HABILIDADES (resolvido por CLASSES_HABILIDADES)
   ============================================================ */


/* ------------------------------------------------------------
   1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
   ------------------------------------------------------------ */
IF DB_ID('JogoRPG') IS NULL
    CREATE DATABASE JogoRPG;
GO

USE JogoRPG;
GO


/* ------------------------------------------------------------
   2. TABELA USUARIOS
   ------------------------------------------------------------ */
CREATE TABLE USUARIOS (
    UsuarioId   INT IDENTITY(1,1) NOT NULL,
    Email       VARCHAR(100)      NOT NULL,
    Senha       VARCHAR(255)      NOT NULL,

    CONSTRAINT PK_USUARIOS       PRIMARY KEY (UsuarioId),
    CONSTRAINT UQ_USUARIOS_Email UNIQUE (Email)
);
GO


/* ------------------------------------------------------------
   3. TABELA CLASSES
   ------------------------------------------------------------ */
CREATE TABLE CLASSES (
    ClasseId    INT IDENTITY(1,1) NOT NULL,
    Nome        VARCHAR(50)       NOT NULL,
    Descricao   VARCHAR(255)      NULL,

    CONSTRAINT PK_CLASSES      PRIMARY KEY (ClasseId),
    CONSTRAINT UQ_CLASSES_Nome UNIQUE (Nome)
);
GO


/* ------------------------------------------------------------
   4. TABELA HABILIDADES
   ------------------------------------------------------------ */
CREATE TABLE HABILIDADES (
    HabilidadeId INT IDENTITY(1,1) NOT NULL,
    Nome         VARCHAR(50)       NOT NULL,

    CONSTRAINT PK_HABILIDADES      PRIMARY KEY (HabilidadeId),
    CONSTRAINT UQ_HABILIDADES_Nome UNIQUE (Nome)
);
GO


/* ------------------------------------------------------------
   5. TABELA PERSONAGENS
      - FK UsuarioId -> USUARIOS (1:N)
      - FK ClasseId  -> CLASSES  (1:N)
   ------------------------------------------------------------ */
CREATE TABLE PERSONAGENS (
    PersonagemId   INT IDENTITY(1,1) NOT NULL,
    NomePersonagem VARCHAR(50)       NOT NULL,
    UsuarioId      INT               NOT NULL,
    ClasseId       INT               NOT NULL,

    CONSTRAINT PK_PERSONAGENS                PRIMARY KEY (PersonagemId),
    CONSTRAINT UQ_PERSONAGENS_NomePersonagem UNIQUE (NomePersonagem),

    CONSTRAINT FK_PERSONAGENS_USUARIOS FOREIGN KEY (UsuarioId)
        REFERENCES USUARIOS (UsuarioId),

    CONSTRAINT FK_PERSONAGENS_CLASSES  FOREIGN KEY (ClasseId)
        REFERENCES CLASSES (ClasseId)
);
GO


/* ------------------------------------------------------------
   6. TABELA CLASSES_HABILIDADES (tabela associativa N:N)
      - Chave primária composta (ClasseId, HabilidadeId)
      - Cada coluna também é chave estrangeira
   ------------------------------------------------------------ */
CREATE TABLE CLASSES_HABILIDADES (
    ClasseId     INT NOT NULL,
    HabilidadeId INT NOT NULL,

    CONSTRAINT PK_CLASSES_HABILIDADES PRIMARY KEY (ClasseId, HabilidadeId),

    CONSTRAINT FK_CLASSES_HABILIDADES_CLASSES FOREIGN KEY (ClasseId)
        REFERENCES CLASSES (ClasseId),

    CONSTRAINT FK_CLASSES_HABILIDADES_HABILIDADES FOREIGN KEY (HabilidadeId)
        REFERENCES HABILIDADES (HabilidadeId)
);
GO


/* ------------------------------------------------------------
   7. CONFERÊNCIA DA ESTRUTURA CRIADA
   ------------------------------------------------------------ */
-- Lista as tabelas do banco
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Lista as colunas e tipos de cada tabela
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Lista as chaves primárias, estrangeiras e únicas
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;
GO
