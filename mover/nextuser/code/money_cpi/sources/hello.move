/*
/// Module: task1
module task1::task1;
*/

module task1::hello;
use std::string::String;
public  fun hello_world( _ctx:&mut TxContext) :String{
		b"Hello charles".to_string()
	
}


#[test]
fun test_hello(){
	let mut ctx = tx_context::dummy();
	let ret = task1::hello::hello_world(&mut ctx);
    let length = ret.length();
    std::debug::print(&length);
	std::debug::print(&ret.index_of(&b"charles".to_string()));
	std::debug::print(&ret.index_of(&b"noexist".to_string()));
}