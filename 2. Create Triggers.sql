--Add Borrowing number by 1 after borrowing items

CREATE OR REPLACE TRIGGER add_borrowing 
    AFTER INSERT ON LOAN_INFO 
    FOR EACH ROW 
    BEGIN
    IF :NEW.RETURN_DATE IS NULL 
    THEN 
    UPDATE MEMBER 
    SET BORROWING = BORROWING +1 
    WHERE :NEW.MEMBER_ID = MEMBER.MEMBER_ID; 
    END IF; 
END; 

/

--Minus Borrowing number by 1 after returning items

CREATE OR REPLACE TRIGGER minus_borrowing 
    AFTER UPDATE OF RETURN_DATE ON LOAN_INFO 
    FOR EACH ROW 
    BEGIN 
    IF :NEW.RETURN_DATE IS NOT NULL AND :OLD.RETURN_DATE IS NULL 
    THEN 
    UPDATE MEMBER 
    SET BORROWING = BORROWING -1 
    WHERE :NEW.MEMBER_ID = MEMBER.MEMBER_ID; 
    END IF; 
END;
/

--Change Item state to 'Out on loan' after being borrowed out

CREATE OR REPLACE TRIGGER borrowed_out 
    AFTER INSERT ON LOAN_INFO 
    FOR EACH ROW 
    BEGIN 
    IF :NEW.RETURN_DATE IS NULL 
    THEN 
    UPDATE ITEM_INFO 
    SET ITEM_STATE = 'Out on loan' 
    WHERE :NEW.ITEM_ID = ITEM_INFO.ITEM_ID; 
    END IF; 
END;
/

--Change Item state to 'In stock' after being returned

CREATE OR REPLACE TRIGGER be_returned 
    AFTER UPDATE OF RETURN_DATE ON LOAN_INFO 
    FOR EACH ROW 
    BEGIN 
    IF :NEW.RETURN_DATE IS NOT NULL AND :OLD.RETURN_DATE IS NULL 
    THEN 
     UPDATE ITEM_INFO 
    SET ITEM_STATE = 'In stock' 
    WHERE :NEW.ITEM_ID = ITEM_INFO.ITEM_ID; 
    END IF; 
END; 

/

--Create member's account after a new Member entry has been made.

CREATE OR REPLACE TRIGGER add_account 
    AFTER INSERT ON MEMBER 
    FOR EACH ROW 
    BEGIN 
    INSERT INTO ACCOUNT VALUES 
    (:NEW.MEMBER_ID,0,'Active'); 
END; 

/

--Accumulate member's total fine to their account

CREATE OR REPLACE TRIGGER acc_fine_and_ban
AFTER INSERT OR UPDATE OF FINE ON EXP_INFO 
FOR EACH ROW 

BEGIN  
    UPDATE ACCOUNT 
    SET TOTAL_FINE = TOTAL_FINE -nvl( :OLD.FINE,0) + nvl(:NEW.FINE,0) 
    WHERE :NEW.MEMBER_ID = ACCOUNT.MEMBER_ID; 

   UPDATE ACCOUNT
   SET STATE = 'Suspended'
   WHERE TOTAL_FINE >= 10; 

END;
/

--Some items are in-library only, can't be borrowed out.

CREATE OR REPLACE TRIGGER inlibrary_items 
   BEFORE INSERT ON LOAN_INFO 
   FOR EACH ROW 
   DECLARE 
   LP NUMBER(2); 
   BEGIN  
    
   SELECT LOAN_PERIOD INTO LP 
   FROM ITEM_INV  
   WHERE ITEM_INV.ITEM_NAME = :NEW.ITEM_NAME; 
 
   IF LP = 0 
   THEN raise_application_error (-20100, 'This Item can only be used in library'); 
   END IF; 
 
END;
/

--Members cannot borrow more than the maximum number of their credit

CREATE OR REPLACE TRIGGER credit_check 
   BEFORE INSERT ON LOAN_INFO 
   FOR EACH ROW 
   DECLARE 
   cre NUMBER(2); 
   bor NUMBER(2); 
   BEGIN  
    
   SELECT LOAN_CREDIT INTO cre 
   FROM MEMBER 
   WHERE MEMBER.MEMBER_ID = :NEW.MEMBER_ID; 
 
   SELECT  BORROWING INTO bor 
   FROM MEMBER 
   WHERE MEMBER.MEMBER_ID = :NEW.MEMBER_ID; 
 
   IF cre=bor 
   THEN raise_application_error (-20100, 'This member has reached the loan limit.'); 
   END IF; 
 
END;
/

