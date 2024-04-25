SELECT * FROM USER_SYS_PRIVS; -- Privilegios do sistema concedidos ao usuário atual
SELECT * FROM USER_TAB_PRIVS; -- Privilegios de tabelas concedidos ao usuário atual
SELECT * FROM USER_ROLE_PRIVS; -- Roles concedidas ao usuário atual
-- verificar os privilégios de outros usuários, 
-- substituir USER_ por ALL_ ou DBA_ 
-- adicionar uma cláusula WHERE para especificar o nome do usuário desejado.


SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'NOME_DO_USUARIO';
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'NOME_DO_USUARIO';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'NOME_DO_USUARIO';

---------
-- GRANT [permissão] ON [objeto] TO [usuário/role];

GRANT SELECT ON employees TO user1;


---
-- REVOKE [permissão] ON [objeto] FROM [usuário/role];
REVOKE SELECT ON employees FROM user1;

--
-- Para ver todos os usuários em um banco de dados Oracle, você pode executar a seguinte consulta:
SELECT username
FROM all_users;
