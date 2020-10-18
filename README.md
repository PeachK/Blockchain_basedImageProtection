# Blockchain_basedImageProtection
use Ethereum/ipfs and zero watermark to protect image copyright
# 一、将合约sol文件生成java文件
1. 将合约文件放入Solidity文件夹下
2. 从cmd进入项目根目录，输入`mvn web3j:generate-sources`
3. 生成的java文件将存入org.web3j.model包下
4. 将生成的java文件复制到model包下即可
# 二、钱包文件生成
``web3j wallet create``

然后按照提示输入钱包密码，指定钱包文件保存位置。

记得在web3Utils类中修改需要使用的钱包文件位置和密码
