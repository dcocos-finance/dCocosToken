echo "deploy dCOCOS, CocosToken, CocosGateway begin....."

TF_CMD=node_modules/.bin/truffle-flattener
TOKEN_LIST=(dCOCOS CocosToken CocosGateway)

for contract in ${TOKEN_LIST[@]};
do
    echo $contract
    $TF_CMD ./contracts/$contract.sol > $contract.full.sol
    solcjs --bin --abi --optimize $contract.full.sol
    mv $contract.full.sol ./deployments/$contract.full.sol 
    mv $contract_full_sol_$contract.bin ./deployments/$contract.full.bin
    mv $contract_full_sol_$contract.abi ./deployments/$contract.full.abi
done

rm *_sol_*

echo "deploy dCOCOS, CocosToken, CocosGateway end....."