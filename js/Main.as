import flash.external.ExternalInterface;

class Main {
  
  static var fromJS:TextField;

  static function main(mc:MovieClip):Void {
    Stage.align = "TL";
    Stage.scaleMode = "noscale";
    Stage.addListener(Main);

    ExternalInterface.addCallback("addOutput", Main, addOutput);
    
    var button:MovieClip = mc.createEmptyMovieClip("button", 1);
    button.onRelease = onRelease;
    button.createTextField("fromJS", 1, 0, 0, 1000, 1000);
    fromJS = button.fromJS;
    fromJS.text = "waiting for JS\n";
    fromJS.multiline = true;
    fromJS.wordWrap = true;
    // Easier to read
    fromJS._xscale = fromJS._yscale = 200;
    
    scaryShit();
    addOutput("Root:\n" + mc.toString());
  }
  
  static function onResize():Void {
    // TextField is scaled 2x
    fromJS._width = Stage.width / 2;
  }

  static function onRelease():Void {
    addOutput("Sending output to console");
    ExternalInterface.call("console.log", fromJS.text)
  }
  
  static function addOutput(text:Object):Void {
    fromJS.text += text.toString() + "\n";
  }
  
  /**
   * monkey patch toString for some primitives
   */
  static function scaryShit():Void {
    // This is how things were done in AS1.
    // Wrote it in '03 sucka http://proto.layer51.com/d.aspx?f=554#c861
    Object.prototype.toString = function() {
    	var s = "{";
    	if (this.$tmpsvar) return "this";
    	this.$tmpsvar = true;
    	_global['ASSetPropFlags'](this, "$tmpsvar", 1);
    	for (var i in this) s += i + ":" + ((typeof(this[i])=='string')?"'"+this[i]+"'":this[i]) + ", ";
    	delete this.$tmpsvar;
    	return s+"}";
    };
    Array.prototype.$toString = Array.prototype.toString;
    Array.prototype.toString = function() {
    	return "[" + this.$toString() + "]";
    };
    _global['ASSetPropFlags'](Array.prototype, ["$toString"], 1);
  }
}
