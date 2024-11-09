
module supply_mint::supply_mint;
use sui::balance::Supply;
use money_cpi::money_cpi::SupplyHold;


public entry fun mint( hold:&mut SupplyHold , amount :u64, ctx:&mut tx_context::TxContext) {
    let balance = hold.supply.increase_supply(amount);
    let coin = sui::coin::from_balance(balance,ctx);
    transfer::public_transfer(coin,tx_context::sender(ctx));

}