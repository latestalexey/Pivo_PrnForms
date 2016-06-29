﻿
&НаКлиенте
Процедура Удалить(Команда)
	
	УдалитьНаСервере(Объект.Организация, Объект.НачПериода, Объект.КонПериода);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНаСервере(Организация, НачПериода, КонПериода)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажах.Ссылка
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.Дата МЕЖДУ &НачПериода И &КонПериода
	|	И ОтчетОРозничныхПродажах.Организация = &Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачПериода", НачПериода);
	Запрос.УстановитьПараметр("КонПериода", КонецДня(КонПериода));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		КассоваяСменаОбъект = Выборка.Ссылка.КассоваяСмена.ПолучитьОбъект();
		Если КассоваяСменаОбъект <> Неопределено Тогда
			Попытка
				КассоваяСменаОбъект.Удалить();
			Исключение
			КонецПопытки;
		КонецЕсли;
	
		ЗапросПодчиненных = Новый Запрос(
		"ВЫБРАТЬ
		|	ЧекККМ.Ссылка
		|ИЗ
		|	Документ.ЧекККМ КАК ЧекККМ
		|ГДЕ
		|	ЧекККМ.ОтчетОРозничныхПродажах = &ОтчетОРозничныхПродажах
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СборкаТоваров.Ссылка
		|ИЗ
		|	Документ.СборкаТоваров КАК СборкаТоваров
		|ГДЕ
		|	СборкаТоваров.ДокументОснование = &ОтчетОРозничныхПродажах
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОприходованиеТоваров.Ссылка
		|ИЗ
		|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
		|ГДЕ
		|	ОприходованиеТоваров.ДокументОснование = &ОтчетОРозничныхПродажах
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВыемкаДенежныхСредствИзКассыККМ.Ссылка
		|ИЗ
		|	Документ.ВыемкаДенежныхСредствИзКассыККМ КАК ВыемкаДенежныхСредствИзКассыККМ
		|ГДЕ
		|	ВыемкаДенежныхСредствИзКассыККМ.ОтчетОРозничныхПродажах = &ОтчетОРозничныхПродажах");
		ЗапросПодчиненных.УстановитьПараметр("ОтчетОРозничныхПродажах", Выборка.Ссылка);
		
		ВыборкаПодчиненных = ЗапросПодчиненных.Выполнить().Выбрать();
		Пока ВыборкаПодчиненных.Следующий() Цикл
			ДокОбъект = ВыборкаПодчиненных.Ссылка.ПолучитьОбъект();
			Попытка
				ДокОбъект.Удалить();
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры
