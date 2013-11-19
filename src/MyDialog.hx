package ;

import flash.text.TextFieldAutoSize;
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
	private var textIndex: Int = 0;
	private var currentPattern: Pattern;

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

		// Création des patterns
		var pattern1 = {name: "Pattern2", texts: ["Bien", "et toi ?"], next: null};
		var pattern0 = {name: "Pattern", texts: ["Salut", "tu", "vas", "bien ?"], next: pattern1};
		currentPattern = pattern0;

		textField = new TextField();

		//Dessine le bouton
		var buttonContent = new Sprite();
		var shape = new Shape();
		shape.graphics.beginFill(0xFF0000);
		shape.graphics.drawRect(0, 0, 100, 50);
		shape.graphics.endFill();
		var buttonText = new TextField();
		buttonText.autoSize = TextFieldAutoSize.CENTER;
		buttonText.defaultTextFormat = new TextFormat("_sans", 10, 0xFFFFFF);
		buttonText.text = "Suivant";
		buttonContent.addChild(shape);
		buttonContent.addChild(buttonText);
		// Centre le texte
		buttonText.x = shape.width / 2 - buttonText.width / 2;
		buttonText.y = shape.height /2 - buttonText.height / 2;
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
		// Vérifier l'indice pour ne pas sortir du tableau et que currentPattern n'est pas null
		if(currentPattern != null && textIndex < currentPattern.texts.length){
			setText(currentPattern.texts[textIndex]);
			textIndex++;
			// En une ligne
			// setText(texts[textIndex++]);
		}
		else if(currentPattern != null){
			// On pourrait aussi désactiver le bouton quand currentPattern est null
			// nextButton.enabled = false;
			// ou carrément lui supprimer son listener
			// nextButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			currentPattern = currentPattern.next;
			textIndex = 0;
			displayNextText();
		}
	}

	// inline : optimisation à la compilation
	private inline function setText(text:String):Void
	{
		textField.text = text;
	}
}

typedef Pattern = {
	var name: String;
	var texts: Array<String>;
	var next: Pattern;
}