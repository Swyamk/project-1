module 0x1::Hospital {
    use aptos_framework::signer;
    use aptos_std::table;

    struct Hospital has copy, drop, store {
        hospital_name: vector<u8>,
        hospital_address: vector<u8>,
        hospital_spec: vector<u8>,
    }

    struct HospitalList has key {
        map: table::Table<u64, Hospital>,
    }

    struct Owner has key {
        address: address,
    }

    public fun initialize(owner: &signer) {
        move_to(owner, Owner { address: signer::address_of(owner) });
        move_to(owner, HospitalList { map: table::new<u64, Hospital>(signer::address_of(owner)) });
    }

    public fun store_hospital_details(
        owner: &signer,
        hospital_id: u64,
        hospital_name: vector<u8>,
        hospital_address: vector<u8>,
        hospital_spec: vector<u8>
    ) {
        let owner_address = signer::address_of(owner);
        let owner_resource = borrow_global<Owner>(owner_address);
        assert!(owner_address == owner_resource.address, 1);
        let hospital_list = borrow_global_mut<HospitalList>(owner_address);
        let hospital = Hospital {
            hospital_name,
            hospital_address,
            hospital_spec,
        };
        table::add(&mut hospital_list.map, hospital_id, hospital);
    }

    public fun retrieve_hospital_details(owner: &signer, hospital_id: u64): (vector<u8>, vector<u8>, vector<u8>) {
        let owner_address = signer::address_of(owner);
        let hospital_list = borrow_global<HospitalList>(owner_address);
        let hospital = table::borrow(&hospital_list.map, hospital_id);
        (hospital.hospital_name, hospital.hospital_address, hospital.hospital_spec)
    }
}
