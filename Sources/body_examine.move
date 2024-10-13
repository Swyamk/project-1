module 0x1::BodyExamine {
    use aptos_framework::signer;
    use aptos_std::table;

    struct Tests has copy, drop, store {
        patient_id: u64,
        blood_test: vector<u8>,
        urine_test: vector<u8>,
        ecg: vector<u8>,
        mri_scan: vector<u8>,
        ct_scan: vector<u8>,
        xray: vector<u8>,
        lab_test: vector<u8>,
    }

    struct Patient has copy, drop, store {
        patient_id: u64,
    }

    struct PatientList has key {
        map: table::Table<u64, Tests>,
    }

    struct Owner has key {
        address: address,
    }

    public fun initialize(owner: &signer) {
        move_to(owner, Owner { address: signer::address_of(owner) });
        move_to(owner, PatientList { map: table::new<u64, Tests>(signer::address_of(owner)) });
    }

    public fun store_tests(
        owner: &signer,
        patient_id: u64,
        blood_test: vector<u8>,
        urine_test: vector<u8>,
        ecg: vector<u8>,
        mri_scan: vector<u8>,
        ct_scan: vector<u8>,
        xray: vector<u8>,
        lab_test: vector<u8>
    ) {
        let owner_address = signer::address_of(owner);
        let owner_resource = borrow_global<Owner>(owner_address);
        assert!(owner_address == owner_resource.address, 1);
        let patient_list = borrow_global_mut<PatientList>(owner_address);
        let tests = Tests {
            patient_id,
            blood_test,
            urine_test,
            ecg,
            mri_scan,
            ct_scan,
            xray,
            lab_test,
        };
        table::add(&mut patient_list.map, patient_id, tests);
    }
}
