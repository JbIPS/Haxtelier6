package ;

import flash.events.MouseEvent;
import flash.display.Shape;
import flash.Lib;
import flash.display.Sprite;
import flash.display.SimpleButton;
import flash.text.TextField;

class MyDialog extends Sprite{

	private var textField: TextField;
	private var nextButton: SimpleButton;
	private var texts: Array<String>;
	private var textIndex: Int = 0;

	/**
	* Méthode d'entrée du programme
	**/
	public static function main():Void
	{
		// Construction de notre dialogue
		new MyDialog();
	}

	public function new():Void
	{
		// Appel du constructeur de Sprite
		super();
		texts = ["Salut", "tu", "vas", "bien ?"];

		textField = new TextField();

		//Dessine le bouton
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 50);
		shape.graphics.endFill();
		// 3 états du bouton + zone de clic
		nextButton = new SimpleButton(shape, shape, shape, shape);
		nextButton.x = 500;
		nextButton.y = 350;
		nextButton.addEventListener(MouseEvent.CLICK, displayNextText);

		display();
	}

	private function display():Void
	{
		addChild(textField);
		addChild(nextButton);

		Lib.current.addChild(this);
	}

	private function displayNextText(e:MouseEvent):Void
	{
		// Vérifier l'indice pour ne pas sortir du tableau
		if(textIndex < texts.length){
			setText(texts[textIndex]);
			textIndex++;
		}
		// En une ligne
		// setText(texts[++textIndex]);
	}

	private function setText(text:String):Void
	{
		textField.text = text;
	}
}