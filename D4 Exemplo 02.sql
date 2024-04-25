CREATE TABLE Conta (
    ContaID INT PRIMARY KEY,
    Saldo DECIMAL(10, 2)
);

CREATE TABLE Transacao (
    TransacaoID INT PRIMARY KEY,
    ContaOrigemID INT,
    ContaDestinoID INT,
    Valor DECIMAL(10, 2),
    Status VARCHAR(20) CHECK (Status IN ('Pendente', 'Concluida', 'Cancelada'))
);

-- Dados de exemplo
INSERT INTO Conta (ContaID, Saldo) VALUES
(1, 1000.00),
(2, 2000.00);

INSERT INTO Transacao (TransacaoID, ContaOrigemID, ContaDestinoID, Valor, Status) VALUES
(1, 1, 2, 500.00, 'Pendente');

SELECT * FROM Transacao;

--------------

CREATE PROCEDURE RealizarTransferencia (
    pTransacaoID IN INT
) AS
    vSaldoOrigem DECIMAL(10, 2);
    vSaldoDestino DECIMAL(10, 2);
	vValorTransacao DECIMAL(10, 2);
BEGIN
    -- Inicia a transação
    BEGIN
        -- Obter saldos atuais das contas de origem e destino
        SELECT Saldo INTO vSaldoOrigem FROM Conta WHERE ContaID = (SELECT ContaOrigemID FROM Transacao WHERE TransacaoID = pTransacaoID);
        SELECT Saldo INTO vSaldoDestino FROM Conta WHERE ContaID = (SELECT ContaDestinoID FROM Transacao WHERE TransacaoID = pTransacaoID);
        
        -- Obter o valor da transação
		SELECT Valor INTO vValorTransacao FROM Transacao WHERE TransacaoID = pTransacaoID;
		
		-- Verifica se a conta de origem tem saldo suficiente
		IF vSaldoOrigem < vValorTransacao THEN
			UPDATE Transacao SET Status = 'Cancelada' WHERE TransacaoID = pTransacaoID;
			RAISE_APPLICATION_ERROR(-20001, 'Saldo insuficiente para a transferência');
		END IF;
        
        -- Atualiza o status da transação para "Concluida" e atualiza os saldos das contas
        UPDATE Transacao SET Status = 'Concluida' WHERE TransacaoID = pTransacaoID;
        UPDATE Conta SET Saldo = Saldo - (SELECT Valor FROM Transacao WHERE TransacaoID = pTransacaoID) WHERE ContaID = (SELECT ContaOrigemID FROM Transacao WHERE TransacaoID = pTransacaoID);
        UPDATE Conta SET Saldo = Saldo + (SELECT Valor FROM Transacao WHERE TransacaoID = pTransacaoID) WHERE ContaID = (SELECT ContaDestinoID FROM Transacao WHERE TransacaoID = pTransacaoID);
        
        -- Confirma a transação
        COMMIT;
    EXCEPTION
        -- Em caso de erro, desfaz a transação
        WHEN OTHERS THEN
            UPDATE Transacao SET Status = 'Cancelada' WHERE TransacaoID = pTransacaoID;
            ROLLBACK;
            RAISE;
    END;
END;
