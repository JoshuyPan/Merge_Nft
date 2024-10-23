module nftmerge::user{

    use std::string::{String};

    public struct User has store, drop, copy {
        username: String,
        address: address,
        mergedNfts: u64,
        grade: String
    }

    public fun create_user(username: String, ctx: &mut TxContext): User {
        User{
            username: username,
            address: tx_context::sender(ctx),
            mergedNfts: 0,
            grade: b"Noob".to_string()
        }
    }

    // Getters
    public fun get_user_name(user: &User): String {
        return user.username
    }

    public fun get_user_address(user: &User): address {
        return user.address
    }

    public fun get_user_merges(user: &User): u64 {
        return user.mergedNfts
    }

    public fun get_user_grade(user: &User): String {
        return user.grade
    }

    // Setters
    public fun add_user_merged(user: &mut User, amount: u64) {
        user.mergedNfts = user.mergedNfts + amount;
        user.try_update_user_grade();
    }

    public fun try_update_user_grade(user: &mut User){
        let userMerges = user.mergedNfts;

        if(userMerges < 1){
            user.grade = b"Noob".to_string();
            return
        };
        if(userMerges < 3){
            user.grade = b"Merger".to_string();
            return
        };
        if(userMerges < 7){
            user.grade = b"Master".to_string();
            return
        };
        user.grade = b"Legend".to_string();
        return
    }

    public fun destroy(user: User) {
        // Destructure the User struct and release its resources
        let User { username: _, address: _, mergedNfts: _, grade: _ } = user;
    }
    
}

