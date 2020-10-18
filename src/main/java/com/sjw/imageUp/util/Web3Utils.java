package com.sjw.imageUp.util;

import com.sjw.imageUp.ImageUpApplication;
import com.sjw.imageUp.model.Greeter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.web3j.crypto.CipherException;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthGetTransactionReceipt;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.Transfer;
import org.web3j.tx.gas.ContractGasProvider;
import org.web3j.tx.gas.DefaultGasProvider;
import org.web3j.utils.Convert;
import org.web3j.utils.Numeric;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Optional;
import java.util.concurrent.ExecutionException;

public class Web3Utils {
    private static final Logger log = LoggerFactory.getLogger(ImageUpApplication.class);
    // We start by creating a new web3j instance to connect to remote nodes on the network.
    // Note: if using web3j Android, use Web3jFactory.build(...

    // FIXME: Enter your Infura token here;
    static Web3j web3j = Web3j.build(new HttpService("https://rinkeby.infura.io/v3/d97604c921cc4edfa5335022ae159b6f"));

    public Optional<TransactionReceipt> getTransactionReceiptByTxH(String transactionHash) {
        try {
            EthGetTransactionReceipt transactionReceipt = web3j.ethGetTransactionReceipt(transactionHash).sendAsync().get();
           // in getTransactionReceiptByTxH function ,the receipt is :0x88f3b0ead33eb3ecce5dae18f619d50f910dbb5dcae776b85a1a40feb2daa36e
            // log.info("in getTransactionReceiptByTxH function ,the receipt is :"+ transactionHash);
            Optional<TransactionReceipt> receipt = transactionReceipt.getTransactionReceipt();


//            String status = receipt.get().getStatus();
//            BigInteger gasUsed = receipt.get().getGasUsed();
//            BigInteger blockNumber = receipt.get().getBlockNumber();
//            String blockHash = receipt.get().getBlockHash();
//            Log.i(TAG, "getTransactionReceipt status : " + status);
//            Log.i(TAG, "getTransactionReceipt gasUsed : " + gasUsed);
//            Log.i(TAG, "getTransactionReceipt blockNumber : " + blockNumber);
//            Log.i(TAG, "getTransactionReceipt blockHash : " + blockHash);
            return receipt;
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void getWeb3ClientVersion() throws IOException {
        log.info("Connected to Ethereum client version: "+web3j.web3ClientVersion().send().getWeb3ClientVersion());
    }
    // load our Ethereum wallet file
    public Credentials loadWallet(String pwd, String pathName) throws IOException, CipherException {
        Credentials credentials = WalletUtils.loadCredentials(pwd,pathName);
        log.info("credentials loaded");
        return credentials;
    }
    //// FIXME: Request some Ether for the Rinkeby test network at https://www.rinkeby.io/#faucet
    public void TransactionTest(Credentials credentials) throws Exception {
        log.info("Sending 1 Wei ("+ Convert.fromWei("1",Convert.Unit.ETHER).toPlainString()+" Ether)");
        TransactionReceipt transferReceipt = Transfer.sendFunds(
                web3j,credentials,
                "0xc98CB8d1A66C09C4C41C9Bb6834acBF7A55e1433", //put any address you want to transfer
                BigDecimal.ONE, Convert.Unit.WEI)
                .send();
        log.info("Transaction complete, view it at https://rinkeby.etherscan.io/tx/"
                + transferReceipt.getTransactionHash());
    }
    //lets deploy smart contract in model package
    public Greeter deployContract(Credentials credentials,String greeting) throws Exception {
        log.info("Deploying smart contract...");
        ContractGasProvider contractGasProvider = new DefaultGasProvider();
        Greeter contract = Greeter.deploy(web3j,credentials,contractGasProvider,greeting).send();

        String contractAddress = contract.getContractAddress();
        log.info("Smart contract deployed to address " + contractAddress);
        log.info("View contract at https://rinkeby.etherscan.io/address/" + contractAddress);

        log.info("Value stored in remote smart contract now: " + contract.greet().send());
        return contract;
    }
    //loading contract deployed before
    public Greeter loadContract(String contractAddr,Credentials credentials) throws Exception {
        log.info("Loading smart contract...");
        ContractGasProvider contractGasProvider = new DefaultGasProvider();
        Greeter contract = Greeter.load(contractAddr,web3j,credentials,contractGasProvider);
        log.info("smart contract loaded from :"+contractAddr);
        log.info("View contract at https://rinkeby.etherscan.io/address/" + contractAddr);

        log.info("Value stored in remote smart contract now: " + contract.greet().send());
        return contract;
    }
    //loading contract by default address
    public  Greeter loadContract(Credentials credentials) throws Exception {
        Greeter contract = loadContract("0x11a561a53369414ef73555072688005d9c4e1d94",credentials);
        return contract;
    }
    //modify value in contract
    public String changeValue(Greeter contract,String newValue) throws Exception {
        log.info("saving new value to contract...");
        TransactionReceipt transactionReceipt = contract.newGreeting(newValue).send();

        log.info("New value stored in remote smart contract: " + contract.greet().send());
        // Events enable us to log specific events happening during the execution of our smart
        // contract to the blockchain. Index events cannot be logged in their entirety.
        // For Strings and arrays, the hash of values is provided, not the original value.
        // For further information, refer to https://docs.web3j.io/filters.html#filters-and-events
        for (Greeter.ModifiedEventResponse event : contract.getModifiedEvents(transactionReceipt)) {
            log.info("Modify event fired, previous value: " + event.oldGreeting
                    + ", new value: " + event.newGreeting);
            log.info("Indexed event previous value: " + Numeric.toHexString(event.oldGreetingIdx)
                    + ", new value: " + Numeric.toHexString(event.newGreetingIdx));
        }
        return transactionReceipt.getTransactionHash();
       
    }
}
