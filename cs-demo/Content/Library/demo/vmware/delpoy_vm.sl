namespace: Integrations.demo.vmware
flow:
  name: delpoy_vm
  workflow:
    - unique_vm_name_generator:
        do:
          io.cloudslang.vmware.vcenter.util.unique_vm_name_generator:
            - vm_name_prefix: RaJ_HCM
        publish:
          - generated_vm_name: '${vm_name}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_username')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_source_identifier: name
            - vm_source: "${get_sp('vcenter_template')}"
            - datacenter: "${get_sp('vcenter_datacenter')}"
            - vm_name: '${generated_vm_name}'
            - vm_folder: "${get_sp('vcenter_folder')}"
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish: []
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: on_failure
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('ubuntu_vm_username')}"
            - password:
                value: "${get_sp('ubuntu_vm_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: '${generated_vm_name}'
            - datacenter: "${get_sp('vcenter_datacenter')}"
        publish: []
        navigate:
          - SUCCESS: wait_for_vm_info
          - FAILURE: on_failure
    - wait_for_vm_info:
        do:
          io.cloudslang.vmware.vcenter.util.wait_for_vm_info:
            - host: "${get_sp('vcenter_host')}"
            - user: "${get_sp('vcenter_username')}"
            - password:
                value: "${get_sp('vcenter_password')}"
                sensitive: true
            - vm_identifier: name
            - vm_name: '${generated_vm_name}'
            - datacenter: "${get_sp('vcenter_datacenter')}"
        publish:
          - vm_ip: '${ip}'
          - vm_full_name: '${guest_full_name}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ip: '${vm_ip}'
    - vm_name: '${vm_full_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      unique_vm_name_generator:
        x: 108
        y: 129
      clone_vm:
        x: 329
        y: 128
      power_on_vm:
        x: 105
        y: 297
      wait_for_vm_info:
        x: 316
        y: 297
        navigate:
          7e01b148-cb20-3122-ed8f-fbf517a6be86:
            targetId: 0b60f519-4203-b3ea-9c57-8f5f5259e946
            port: SUCCESS
    results:
      SUCCESS:
        0b60f519-4203-b3ea-9c57-8f5f5259e946:
          x: 484
          y: 302
