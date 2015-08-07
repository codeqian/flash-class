package myClass
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.text.*;

	/**
	 * 动态文本抗锯齿
	 * @author qzd
	 */
	public class TextAntiAlias extends MovieClip
	{
		private var tf:TextFormat = new TextFormat("SimHei", 24);
		private var txt:TextField=new TextField();
		private var bp:Bitmap;
		private var bd:BitmapData;
		private var quality:Number = 4;
		public function TextAntiAlias() 
		{
			txt.autoSize = TextFieldAutoSize.LEFT;
			bp = new Bitmap();
			this.addChild(bp);
			bp.scaleX = bp.scaleY = 1 / quality;
			bp.smoothing = true;
		}
		public function Text(info:String) {
			txt.text = info;
			txt.setTextFormat(tf);
		}
		public function setText(_text:String, _font:String = "SimHei", _size:int = 16, _color:uint = 0x000000,_width:int = 0,_heigth:int = 0,_align:String = "center") {
			tf.font = _font;
			tf.size = _size;
			tf.color = _color;
			tf.align = _align;
			var mat:Matrix = new Matrix();
            mat.scale(quality, quality);
			if (_width > 0) {
				txt.autoSize =  TextFieldAutoSize.NONE;
				txt.wordWrap = true;
				txt.multiline = true;
				txt.width = _width
				txt.height = _heigth;
			}
			txt.text = _text;
			txt.setTextFormat(tf);
			bd = new BitmapData(txt.width * quality, txt.height * quality, true, 0x000000);
			bp.bitmapData = bd;
			bd.draw(txt, mat);
		}
	}
}