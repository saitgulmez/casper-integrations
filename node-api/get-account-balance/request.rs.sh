# -----------------------------------------------------------
# Retrieve account balance by purse.
# -----------------------------------------------------------

# NOTE: $CASPER_CLIENT = path to compiled casper-client binary.

# An adddress associated with a casper test-net node.
_NODE_ADDRESS="http://3.136.227.9:7777/rpc"

# An on-chain account key.
_ACCOUNT_KEY="01cb99ab80325d73552c7c0b8d10d8cb2d19116b1f233431751fe82f9c25db51c1"

# An on-chain account hash.
_ACCOUNT_HASH=$($CASPER_CLIENT account-address -p $_ACCOUNT_KEY)

# A known state of the linear block chain at which to query.
_STATE_ROOT_HASH="33e257bc70f7094d030a18f8aede3d58d8e202fb946810ce3292625fe853b636"

# Set account purse.
_ACCOUNT_PURSE=$(
    $CASPER_CLIENT query-state \
        --node-address "$_NODE_ADDRESS" \
        --state-root-hash "$_STATE_ROOT_HASH" \
        --key "$_ACCOUNT_KEY" \
        | jq '.result.stored_value.Account.main_purse' \
        | sed -e 's/^"//' -e 's/"$//'
    )

# Set account balance.
_ACCOUNT_BALANCE=$(
    $CASPER_CLIENT get-balance \
        --node-address "$_NODE_ADDRESS" \
        --state-root-hash "$_STATE_ROOT_HASH" \
        --purse-uref $_ACCOUNT_PURSE \
        | jq '.result.balance_value' \
        | sed -e 's/^"//' -e 's/"$//'
    )

echo "-----------------------------------------------------------------------------------------------------"
echo "QUERIED TEST-NET NODE $_NODE_ADDRESS @ $_STATE_ROOT_HASH"
echo "-----------------------------------------------------------------------------------------------------"
echo "A/C key = $_ACCOUNT_KEY"
echo "A/C hash = $_ACCOUNT_HASH"
echo "A/C purse = $_ACCOUNT_PURSE"
echo "A/C balance = $_ACCOUNT_BALANCE"