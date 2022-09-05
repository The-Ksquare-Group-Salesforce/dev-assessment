@IsTest
public class TriggerHandlerTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.insertData(10);
    }
    @IsTest
    static void testInsert(){
        insert TestDataFactory.getAccounts(1);
    }
    @IsTest
    static void testUpdate(){
        update [Select Id From Account];
    }
    @IsTest
    static void testDelete(){
        delete [Select Id From Contact];
        delete [Select Id From Account];
    }
    @IsTest
    static void testUndelete(){
        delete [Select Id From Contact];
        delete [Select Id From Account];
        undelete [Select Id From Account ALL ROWS];
    }
}