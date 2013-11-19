package ;

import flash.text.TextFormat;
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
	private var pattern: Pattern;

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
		var newPattern = {name: "Pattern2", texts: ["Bien", "et toi ?"], next: null};
		pattern = {name: "Pattern", texts: texts, next: newPattern};

		textField = new TextField();

		//Dessine le bouton
		var buttonContent = new Sprite();
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 50);
		shape.graphics.endFill();
		var buttonText = new TextField();
		buttonText.defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFF);
		buttonText.text = "Suivant";
		buttonContent.addChild(shape);
		buttonContent.addChild(buttonText);
		// 3 états du bouton + zone de clic
		nextButton = new SimpleButton(buttonContent, buttonContent, buttonContent, buttonContent);
		nextButton.x = 500;
		nextButton.y = 350;
		nextButton.addEventListener(MouseEvent.CLICK, onButtonClick);
		textField.addEventListener(MouseEvent.CLICK, onButtonClick);

		display();
	}

	private function display():Void
	{
		addChild(textField);
		addChild(nextButton);

		Lib.current.addChild(this);
	}

	private function onButtonClick(e: MouseEvent):Void
	{
		displayNextText();
	}

	private function displayNextText():Void
	{
		// Vérifier l'indice pour ne pas sortir du tableau
		if(textIndex < pattern.texts.length){
			if(pattern != null){
				setText(pattern.texts[textIndex]);
				textIndex++;
			}
		}
		else{
			pattern = pattern.next;
			textIndex = 0;
			displayNextText();
		}
		// En une ligne
		// setText(texts[textIndex++]);
	}

	private function setText(text:String):Void
	{
		textField.text = text;
	}
}

typedef Pattern = {
	var name: String;
	var texts: Array<String>;
	var next: Pattern;
}