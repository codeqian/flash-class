package
{
	import flash.utils.ByteArray;
	/*bitmap字符串的压缩与解压,用于p2p数据块地图的传输。数据块地图原数据为类似101010101012030的字符串，在传输时将其压缩为整型数通过ByteArray传递。
	* 公共方法：
	* compressBitmap    bitmap转换为整型数存入ByteArray
	* uncompressBitmap    从ByteArray中读取整型数还原为bitmap字符串
	* */
	public class compressBitmap
	{
		/**
		 * 压缩bitmap 
		 * @param bm
		 * @return 
		 * 
		 */		
		private static function compressBitmap(bm:String):ByteArray{
			var tpby:ByteArray=new ByteArray();
			var i:int=0;
			while(i<bm.length){
				var tpStr:String=bm.substr(i,7);
				var tpLength:int=tpStr.length;
				if(tpLength<7){
					for(var t:int=0;t<7-tpLength;t++){
						tpStr+="0";
					}
				}
				tpby.writeByte(parseInt(tpStr, 2));
				i+=7;
			}
			return tpby;
		}
		/**
		 * 解压缩bitmap 
		 * @param bm
		 * @return 
		 * 
		 */		
		private static function uncompressBitmap(bm:ByteArray):String{
			var tpbm:String="";
			bm.position=0;
			for(var i:int=0;i<bm.length;i++){
				var tpStr:String=bm.readByte().toString(2);
				var tpLength:int=tpStr.length;
				if(tpLength<7){
					for(var t:int=0;t<7-tpLength;t++){
						tpStr="0"+tpStr;
					}
				}
				tpbm+=tpStr;
			}
			return tpbm;
		}
	}
}