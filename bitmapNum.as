package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 显示位图数字，数字原型由一个png图像提供 
	 * @author QZD
	 * 
	 */
	public class bitmapNum extends Sprite
	{
		/**
		 * 显示对象 
		 */		
		private var numBm:Bitmap;
		/**
		 * 生成的数字bitmapdata 
		 */		
		private var numBd:BitmapData;
		/**
		 * 库里的素材bitmapdata 
		 */		
		private var numImg:BitmapData;
		private var numw:Number;
		private var numh:Number;
		/**
		 * 构造函数 
		 * @param lib_class 图像原件
		 * 
		 */		
		public function bitmapNum(lib_class:BitmapData = null)
		{
			numImg=lib_class;
			numw=numImg.width/10;
			numh=numImg.height;
		}
		/**
		 * 显示数字 
		 * @param _num 输入的数字
		 * @return 最后生成的文字图片的宽度
		 * 
		 */		
		public function showNum(_num:int){
			var tpAr:Array=String(_num).split("");
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			if(numBd){
				numBd.dispose();
				numBm=null;
			}
			numBd=new BitmapData(numw*tpAr.length,numh,true,0);
			for(var i:int=0;i<tpAr.length;i++){
				numBd.copyPixels(numImg,new Rectangle(numw*tpAr[i],0,numw,numh),new Point(numw*i,0));
			}
			numBm=new Bitmap(numBd);
			addChild(numBm);
			return numBd.width;
		}
		/**
		 * 销毁 
		 * @return 
		 * 
		 */		
		public function destroy(){
			numImg.dispose();
			numBd.dispose();
			numBm=null;
		}
	}
}