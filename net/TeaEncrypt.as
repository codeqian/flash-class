
/* TEA 对称性加密/解密函数  
 * @author cheche 2010-8
 
 算法简介：
 该算法使用 128 位的密钥为 64 位的信息块进行加密，它需要进行 64(8的整数倍32、16等)轮迭代。
 该算法使用了一个神秘常数δ作为倍数，它来源于黄金比率，以保证每一轮加密都不相同。这里 TEA 
 把它定义为 δ=(sqrt(5)-1)/2*2^32（也就是程序中的 0×9E3779B9）。 本次算法使用16轮加密。每
 次加密8字节数据，如在数据结尾，获得的字节数据不足8字节，则对小于8字节数据不进行加密处理
 ，因此加密后数据包大小不变。
 
 */

package net 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TeaEncrypt {
		//加密轮数
		private static var round:uint=16;
		//密钥
		private static var key:String="3A DA 75 21 DB E3 DB B3 62 B7 49 01 A5 C6 EA D5";
        //-----------加密  参数（要加密的数据） 返回：加密后的数据
		public static var isNetData:Boolean = true;
		
		public static function teaEncrypt(enData:ByteArray):ByteArray {
			enData.position=0;
			//trace("加密数据>>>>"+ByteArrayToLongArray(enData,false));
			var len:uint=Math.ceil(enData.length/8);
			//trace("加密次数>>>"+len);
			//存放加密结果
			var resData:ByteArray = new ByteArray();
			resData.position=0;
			resData.endian=Endian.BIG_ENDIAN;
			//不足8字节时，未加密数据临时存放
			var nData:ByteArray = new ByteArray();
				nData.position=0;
				nData.endian=Endian.BIG_ENDIAN;
			
			enData.position=0;
			for (var i:uint=0; i<len; i++) {
				//保存截取的8字节数据
				var enBytes:ByteArray = new ByteArray();
				enBytes.position=0;
				enBytes.endian=Endian.BIG_ENDIAN;

				if (enData.bytesAvailable>=8) {
					//数据队列中读取8字节数据
					enData.readBytes(enBytes,0,8);
					var encrypted:ByteArray =  new ByteArray();
					encrypted.position=0;
					encrypted.endian=Endian.BIG_ENDIAN;
					//------------------------加密处理---------------------------
					encrypted = encrypt(enBytes);
					//------------------------加密处理---------------------------
					resData.writeBytes(encrypted,0,encrypted.length);
                    encrypted.clear();
				    encrypted=null;
				} else {
					enData.readBytes(nData,0,enData.bytesAvailable);
				}
                enBytes.clear();
				enBytes=null;
			}
				
			nData.position=0;
			if (nData.length>0) {
				resData.writeBytes(nData,0,nData.length);
			}
			nData.clear();
			nData=null;
			enData.clear();
			enData=null;
			
			return resData;
            resData.clear();
			resData=null;
		}
		//--------------------------------------------------------------------------------------------------------------
		//-----------解密  参数（要解密的数据） 返回：解密后的数据
		public static function teaDecrypt(decData:ByteArray):ByteArray {
			isNetData = true;
			
			if(isNetData){
				decData.endian = Endian.BIG_ENDIAN;
			}else{
				decData.endian = Endian.LITTLE_ENDIAN;
			}
			
			decData.position=0;
			var len:uint=Math.ceil(decData.length/8);
			
			var resData:ByteArray = new ByteArray();
			resData.position=0;
			if(isNetData){
				resData.endian=Endian.BIG_ENDIAN;
			}else{
				resData.endian=Endian.LITTLE_ENDIAN;
			}
			
			
			var nData:ByteArray = new ByteArray();
				nData.position=0;
			if(isNetData){
				nData.endian=Endian.BIG_ENDIAN;
			}else{
				nData.endian=Endian.LITTLE_ENDIAN;
			}
				
			
			decData.position=0;
			for (var i:uint=0; i<len; i++) {
				var decBytes:ByteArray = new ByteArray();
				decBytes.position=0;
				if(isNetData){
				  decBytes.endian=Endian.BIG_ENDIAN;
			    }else{
				  decBytes.endian=Endian.LITTLE_ENDIAN;
			    }
				
				if (decData.bytesAvailable>=8) {
					decData.readBytes(decBytes,0,8);
				    var decrypted:ByteArray =  new ByteArray();
				    decrypted.position=0;
					if(isNetData){
				       decrypted.endian=Endian.BIG_ENDIAN;
			        }else{
				       decrypted.endian=Endian.LITTLE_ENDIAN;
			        }
				    
				    //------------------------解密处理---------------------------
				    decrypted=decrypt(decBytes);
				    //------------------------解密处理---------------------------
					
					decrypted.position=0;
				    resData.writeBytes(decrypted,0,decrypted.length);
				    decrypted.clear();
					decrypted=null;
				} else {
					decData.readBytes(nData,0,decData.bytesAvailable);
				}
				decBytes.clear();
				decBytes=null;
			}

			nData.position=0;
			if (nData.length>0) {
				resData.writeBytes(nData,0,nData.length);
			}
			decData.clear();
			decData=null;
			nData.clear();
			nData=null;

			return resData;
			resData.clear();
			resData=null;
		}

		private static function LongArrayToByteArray(data : Array, includeLength : Boolean):ByteArray {
			
			var len:uint=data.length;
			var resultArr : ByteArray = new ByteArray();
			resultArr.position=0;
			resultArr.endian=Endian.BIG_ENDIAN;
			for (var i : uint = 0; i < len; i++) {
				resultArr.writeUnsignedInt(data[i]);
			}
			return resultArr;
			
		}
        private static function LongArrayToByteArray2(data : Array, includeLength : Boolean):ByteArray {
			
			var len:uint=data.length;
			if(isNetData){
				data.endian = Endian.LITTLE_ENDIAN;
			}else{
				data.endian=Endian.BIG_ENDIAN;
			}
            
			data.position=0;
			var resultArr : ByteArray = new ByteArray();
			resultArr.position=0;
			if(isNetData){
				resultArr.endian = Endian.LITTLE_ENDIAN;
			}else{
				resultArr.endian=Endian.BIG_ENDIAN;
			}
			
			for (var i : uint = 0; i < len; i++) {
				resultArr.writeUnsignedInt(data[i]);
			}
			return resultArr;
			
		}
		private static function ByteArrayToLongArray(data : ByteArray, includeLength : Boolean):Array {
			var len:uint=data.length;
			var n:uint=len>>2;
			if(isNetData){
				data.endian=Endian.BIG_ENDIAN;
			}else{
				data.endian=Endian.LITTLE_ENDIAN;
			}
			
			data.position=0;
			var resultArr:Array=[];
			for (var i : uint = 0; i < n; i++) {
				resultArr[i]=data.readUnsignedInt();
			}
			
			return resultArr;
		}
		
		private static function ByteArrayToLongArray2(data : ByteArray, includeLength : Boolean):Array {
			var len:uint=data.length;
			var n:uint=len>>2;
			
			data.endian=Endian.LITTLE_ENDIAN;
			data.position=0;
			var resultArr:Array=[];
			for (var i : uint = 0; i < n; i++) {
				resultArr[i]=data.readUnsignedInt();
			}
			
			return resultArr;
		}
		//------------------------------------------------------------------------------------------------
        
		private static function encrypt(data:ByteArray):ByteArray {

			if (data.length==0) {
				return new ByteArray();
			}
			var v:Array=ByteArrayToLongArray(data,false);
			var k:Array=getMyKey(key);
			//var k:Array=[987395361,3689143219,1656178945,2781276885];
			
			var y:uint=v[0];
			var z:uint=v[1];

			var a:uint=k[0];
			var b:uint=k[1];
			var c:uint=k[2];
			var d:uint=k[3];
			
			var delta=0x9E3779B9;/* (sqrt(5)-1)/2*2^32 */

			var sum:uint=0;
			
			for (var i:uint=0; i<round; i++) {
				sum+=delta;
				y += ((z<<4) + a) ^ (z + sum) ^ ((z>>>5) + b);
				z += ((y<<4) + c) ^ (y + sum) ^ ((y>>>5) + d);
			}
			v[0]=y;
			v[1]=z;
        
			return LongArrayToByteArray(v,false);
		}

		private static function decrypt(data : ByteArray):ByteArray {
			data.position=0;
			if(isNetData){
				data.endian=Endian.BIG_ENDIAN;
			}else{
				data.endian=Endian.LITTLE_ENDIAN;
			}
		
			if (data.length==0) {
				return new ByteArray();
			}
			var v:Array=ByteArrayToLongArray(data,false);
			var k:Array=getMyKey(key);
			//var k:Array=[987395361,3689143219,1656178945,2781276885];
			
			var y:uint=v[0];
			var z:uint=v[1];
			var a:uint=k[0];
			var b:uint=k[1];
			var c:uint=k[2];
			var d:uint=k[3];
			var delta=0x9E3779B9;/* (sqrt(5)-1)/2*2^32 */
			var sum:uint=0;

			if (round==32) {
				sum=0xC6EF3720;//delta << 5
			} else if (round == 16) {
				sum=0xE3779B90;//delta << 4
			}
		
		for (var i:uint = 0; i < round; i++) {/* basic cycle start */
		
			z -= ((y << 4) + c) ^ (y + sum) ^ ((y >>>5) + d);
			y -= ((z << 4) + a) ^ (z + sum) ^ ((z >>>5) + b);
			sum-=delta;

		}
		
		v[0]=y;
		v[1]=z;
		
		return LongArrayToByteArray2(v, false);
	}

	//------------------------------------------------------------------------------------------------------------

	private static function getMyKey(keyStr:String):Array {
		
			var strToArr:Array = new Array();
			var resArr:Array = new Array();
			
			strToArr=keyStr.split(" ");
			var curStr:String="";
			for (var i:uint=0; i<strToArr.length; i++) {
				curStr+=strToArr[i];
			}
			strToArr=null;
			for (i=0; i<curStr.length/8; i++) {
				var tNum:uint = uint("0x"+curStr.slice(i*8,(i+1)*8));
				resArr.push(tNum);
			}
			return resArr;
	}

   }
}