﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ШК = ЭлементыФормы.ШК;
	
	ШК.Штрихкод  =  "RTU_" + Строка(ЭтотОбъект.СсылкаНаОбъект.УникальныйИдентификатор());
	ШК.ВыводитьТекст = Ложь;
	//ШК.ШиринаШтрихкода = 120;
	//ШК.ВысотаШтрихкода = 120;
	ШК.ТипШтрихкода = "QR Code";
	//ШК.
	ШК.Сгенерировать();
	ШК.СохранитьКартинку(КаталогВременныхФайлов() + "RTU_" + Строка(ЭтотОбъект.СсылкаНаОбъект.УникальныйИдентификатор()) + ".gif", "gif");

	Отказ = Истина;
КонецПроцедуры
