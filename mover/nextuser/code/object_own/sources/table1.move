
module object_own::table1{
    use sui::table::{Table,Self};
    use sui::tx_context::{TxContext};
    
    #[allow(unused_use)]
    public struct IntegerTable{
        table_values:Table<u8,u8>
    }

    public struct GenericTable<phantom K:  copy + drop + store,  phantom V:store>{
        table_values:Table<K,V>
    }

    public fun add<K:copy + drop + store, V:store>(
        tb:&mut GenericTable<K,V>,
        k:K,
        v:V
        )
    {
      
        table::add( &mut tb.table_values,k,v);
    }

    public fun remove<K:copy+drop+store,V:store>(
        tb : &mut GenericTable<K,V>,
        k : K,
    ){
        tb.remove(k);
    }

    public fun borrow<K:copy+drop+store,V:store>(
        tb : &mut GenericTable<K,V>,
        k : K,
    ) : &V
    {
        tb.table_values.borrow(k)
    }

    public fun borrow_mut<K:copy+drop+store,V:store>(
        tb : &mut GenericTable<K,V>,
        k : K,
    ) : &mut V
    {
        tb.table_values.borrow_mut(k)
    }




    public fun contains<K:copy+drop+store,V:store>(
        tb : &mut GenericTable<K,V>,
        k : K,
    ):bool
    {
        tb.table_values.contains(k)
    }

    public fun length<K:copy+drop+store,V:store>(
        tb : &mut GenericTable<K,V>,
        k : K,
    ):u64{
        sui::table::length(&tb.table_values)
    }
}

module object_own::test_table{
    use std::string::String;
    use sui::table::{Self,Table};
    #[test]
    fun test_table(){
        let mut ctx = tx_context::dummy();
        let mut tb = sui::table::new<String,u32>(&mut ctx);    
        tb.add(b"abc".to_string(),1);
        tb.add(b"def".to_string(),2);
        tb.add(b"opq".to_string(),3);
        tb.add(b"rst".to_string(),4);
        assert!(tb.length() == 4);
        assert!(tb.contains(b"opq".to_string()));
        assert!(!tb.contains(b"unknown".to_string()));
        sui::test_utils::destroy(tb);
    }


}