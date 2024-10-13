module 0x1::Patient {
    use aptos_framework::signer;
    use aptos_std::table;

    struct Attendant has copy, drop, store {
        attendant_name: vector<u8>,
        attendant_relation: vector<u8>,
        attendant_phn_no: u64,
    }

    struct AttendantList has key {
        map: table::Table<u64, Attendant>,
    }

    struct Owner has key {
        address: address,
    }

    public fun initialize(owner: &signer) {
        move_to(owner, Owner { address: signer::address_of(owner) });
        move_to(owner, AttendantList { map: table::new<u64, Attendant>(signer::address_of(owner)) });
    }

    public fun store_attendant_details(
        owner: &signer,
        patient_id: u64,
        attendant_name: vector<u8>,
        attendant_relation: vector<u8>,
        attendant_phn_no: u64
    ) {
        let owner_address = signer::address_of(owner);
        let owner_resource = borrow_global<Owner>(owner_address);
        assert!(owner_address == owner_resource.address, 1);
        let attendant_list = borrow_global_mut<AttendantList>(owner_address);
        let attendant = Attendant {
            attendant_name,
            attendant_relation,
            attendant_phn_no,
        };
        table::add(&mut attendant_list.map, patient_id, attendant);
    }
}
