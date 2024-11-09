
module money_cpi::money_cpi;

public struct MONEY_CPI has drop{}

const  BASE_SUPPLY:u64 = 1000_000_000_0000_0000;// 1 billion  with 8 decimals
use sui::coin::{Self,Coin};
use sui::balance::Supply;
use sui::tx_context::TxContext;

const TIME_SPAN:u64 = 365 * 24 *3600 *1000; // about 1year ,mint once every 365 days


public struct SupplyHold has key{
    id:UID,
    recipient:address,
    supply:Supply<MONEY_CPI>,
    last_mint_time_ms:u64,
}


fun init(otw:MONEY_CPI,ctx:&mut TxContext){
    assert!(sui::types::is_one_time_witness(&otw));
    let (cap,meta) = sui::coin::create_currency(otw, 
            8, 
            b"PT", 
            b"Pound", 
            b"Pounds limit to increase by cpi", 
            option::none(), 
            ctx);
    sui::transfer::public_freeze_object(meta);

    //let balance = cap.supply_mut().increase_supply(BASE_SUPPLY);
    let mut supply = cap.treasury_into_supply();
    let balance = supply.increase_supply(BASE_SUPPLY);
    let caller = tx_context::sender(ctx);
    let hold = SupplyHold { 
        id : object::new(ctx),
        recipient:caller,
        supply,
        last_mint_time_ms : ctx.epoch_timestamp_ms(),
        };
    
    let coin = sui::coin::from_balance(balance, ctx);

    sui::transfer::public_transfer(coin,caller);
    sui::transfer::share_object(hold);
}


public entry fun mint( hold :&mut SupplyHold, amount:u64,ctx:&mut TxContext){
    let currTime = ctx.epoch_timestamp_ms();
    assert!(currTime > hold.last_mint_time_ms  + TIME_SPAN) ;
    hold.last_mint_time_ms = currTime;
    
    
    let total = sui::balance::supply_value(&hold.supply);
    

    assert!( (total + amount)* 100 < total * 103 );
    let balance = sui::balance::increase_supply(&mut hold.supply, amount);
    let coin = sui::coin::from_balance(balance, ctx);
    sui::transfer::public_transfer(coin, hold.recipient);

}
