-- Cria a tabela Conta
CREATE TABLE Conta (
    ContaID INT PRIMARY KEY,
    Saldo DECIMAL(10, 2)
);

-- Insere dados de exemplo
INSERT INTO Conta (ContaID, Saldo) 
    VALUES (1, 1000.00);
INSERT INTO Conta (ContaID, Saldo) 
    VALUES (2, 2000.00);

SELECT * FROM Conta;

SELECT * FROM V$VERSION;

-- Inicia a transação
BEGIN
SAVEPOINT inicio;

	-- Tenta realizar a transferência
	UPDATE Conta SET Saldo = Saldo - 500.00 WHERE ContaID = 1;
	UPDATE Conta SET Saldo = Saldo + 500.00 WHERE ContaID = 2;

	-- Verifica se houve algum problema
	-- Simulando um erro aqui
	IF 1=1 THEN
		-- Se houver, faz rollback até o savepoint
		ROLLBACK TO SAVEPOINT inicio;
	ELSE
		-- Se estiver tudo certo, faz commit
		COMMIT;
	END IF;
END;

---
-- Inicia a transação
BEGIN
SAVEPOINT inicio;

-- Tenta realizar a transferência
UPDATE Conta SET Saldo = Saldo - 500.00 WHERE ContaID = 1;
UPDATE Conta SET Saldo = Saldo + 500.00 WHERE ContaID = 2;


    -- Se estiver tudo certo, faz commit
    COMMIT;
END;