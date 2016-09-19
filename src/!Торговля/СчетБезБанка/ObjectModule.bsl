﻿// Внешняя функция печати
// КТ-2000: (095)789-3070
// Параметры
//  ИмяМакета  – Строка – имя формы печати
//
// Возвращаемое значение:
//   Булево   –Печать прошла успешно - Истина, иначе - Ложь
//
Функция Печать(ИмяМакета = "", ПараметрыПечати = Неопределено)	Экспорт

	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(СсылкаНаОбъект.Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат Ложь;
	КонецЕсли;
	
	ТабДокумент = ПечатьДокумента(СсылкаНаОбъект);
	
	//Определим параметры печати
	Если ПараметрыПечати <> Неопределено Тогда
		КоличествоЭкземпляров = 1;
		Если НЕ(ПараметрыПечати.Свойство("КоличествоЭкземпляров",КоличествоЭкземпляров)) Тогда
			КоличествоЭкземпляров = 1;			
		КонецЕсли;
		НаПринтер = Ложь;
		Если НЕ(ПараметрыПечати.Свойство("НаПринтер",НаПринтер)) Тогда
			НаПринтер = Ложь;			
		КонецЕсли;
	КонецЕсли;
	Если КоличествоЭкземпляров = Неопределено Тогда
		КоличествоЭкземпляров = 1;
	КонецЕсли;
	Если НаПринтер = Неопределено Тогда
		НаПринтер = Ложь;
	КонецЕсли;
//---КТ-2000-(095)789-3070---Олег-27.06.05
	//НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ВыбОбъект));
	Возврат ТабДокумент;
//---КТ-2000-(095)789-3070---Олег-27.06.05

КонецФункции // Печать()

Функция ПечатьДокумента(СсылкаНаДокумент)
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";
	ПараметрыПечати=ПолучитьПараметрыПечатиСчетаЗаказа(СсылкаНаДокумент);
	Макет = ПолучитьМакет("СчетЗаказ");

	// Выводим шапку накладной

	ОбластьМакета       = Макет.ПолучитьОбласть("ЗаголовокСчета");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
	ОбластьСкидок = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
	Если Не ПараметрыПечати.ВыводитьКоды И ПараметрыПечати.ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезКодов");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезСкидок");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И НЕ ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("ШапкаТаблицы|ТоварБезКодовИСкидок");
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьНомера);
	Если ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьКодов.Параметры.ИмяКолонкиКодов = ПараметрыПечати.ИмяКолонкиКодов;
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ОбластьТовар.Параметры.Товар = "Товары (работы, услуги)";
	ТабДокумент.Присоединить(ОбластьТовар);
	ТабДокумент.Присоединить(ОбластьДанных);
	Если ПараметрыПечати.ЕстьСкидки Тогда
		ТабДокумент.Присоединить(ОбластьСкидок);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьСуммы);

	// Увеличим ширину колонки Товар на ширину неиспользуемых колонок
	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ПараметрыПечати.ВыводитьКоды И ПараметрыПечати.ЕстьСкидки Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 1.5;
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 2.125;
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И НЕ ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки * 2.625;
	КонецЕсли;

	ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
	ОбластьСкидок = Макет.ПолучитьОбласть("Строка|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("Строка|Товар");
	Если Не ПараметрыПечати.ВыводитьКоды И ПараметрыПечати.ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезКодов");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезСкидок");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И НЕ ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Строка|ТоварБезКодовИСкидок");
	КонецЕсли;

	Для каждого ПараметрыПозиции Из ПараметрыПечати.Позиции Цикл 

		Если НЕ ЗначениеЗаполнено(ПараметрыПозиции.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьНомера.Параметры.Заполнить(ПараметрыПозиции);
		ТабДокумент.Вывести(ОбластьНомера);

		Если ПараметрыПечати.ВыводитьКоды Тогда
			ОбластьКодов.Параметры.Заполнить(ПараметрыПозиции);
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;

		ОбластьТовар.Параметры.Заполнить(ПараметрыПозиции);
		ТабДокумент.Присоединить(ОбластьТовар);
		ОбластьДанных.Параметры.Заполнить(ПараметрыПозиции);
		ТабДокумент.Присоединить(ОбластьДанных);

		Если ПараметрыПечати.ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.Заполнить(ПараметрыПозиции);
			ТабДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;

		ОбластьСуммы.Параметры.Заполнить(ПараметрыПозиции);
		ТабДокумент.Присоединить(ОбластьСуммы);
		
	КонецЦикла;

	// Вывести Итого
	ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьКодов  = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
	ОбластьСкидок = Макет.ПолучитьОбласть("Итого|Скидка");
	ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");

	ОбластьТовар = Макет.ПолучитьОбласть("Итого|Товар");
	Если Не ПараметрыПечати.ВыводитьКоды И ПараметрыПечати.ЕстьСкидки Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезКодов");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезСкидок");
	ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И НЕ ПараметрыПечати.ВыводитьКоды Тогда
		ОбластьТовар = Макет.ПолучитьОбласть("Итого|ТоварБезКодовИСкидок");
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьНомера);
	Если ПараметрыПечати.ВыводитьКоды Тогда
		ТабДокумент.Присоединить(ОбластьКодов);
	КонецЕсли;
	ТабДокумент.Присоединить(ОбластьТовар);
	ТабДокумент.Присоединить(ОбластьДанных);
	Если ПараметрыПечати.ЕстьСкидки Тогда
		ОбластьСкидок.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Присоединить(ОбластьСкидок);
	КонецЕсли;
	ОбластьСуммы.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Присоединить(ОбластьСуммы);

	// Вывести ИтогоНДС
	Если ПараметрыПечати.УчитыватьНДС Тогда
		ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
		ОбластьКодов  = Макет.ПолучитьОбласть("ИтогоНДС|КолонкаКодов");
		ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
		ОбластьСкидок = Макет.ПолучитьОбласть("ИтогоНДС|Скидка");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");

		ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|Товар");
		Если Не ПараметрыПечати.ВыводитьКоды И ПараметрыПечати.ЕстьСкидки Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезКодов");
		ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И ПараметрыПечати.ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезСкидок");
		ИначеЕсли НЕ ПараметрыПечати.ЕстьСкидки И НЕ ПараметрыПечати.ВыводитьКоды Тогда
			ОбластьТовар = Макет.ПолучитьОбласть("ИтогоНДС|ТоварБезКодовИСкидок");
		КонецЕсли;

		ТабДокумент.Вывести(ОбластьНомера);
		Если ПараметрыПечати.ВыводитьКоды Тогда
			ТабДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ОбластьТовар.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Присоединить(ОбластьТовар);
		ОбластьДанных.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Присоединить(ОбластьДанных);
		Если ПараметрыПечати.ЕстьСкидки Тогда
			ТабДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		ОбластьСуммы.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Присоединить(ОбластьСуммы);
	КонецЕсли;

	// Вывести Сумму прописью
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчета");
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
	
	ТабДокумент.Вывести(ОбластьМакета);

	Возврат ТабДокумент;	
КонецФункции

Функция ПолучитьПараметрыПечатиСчетаЗаказа(ПечДокумент) Экспорт	
	Если ТипЗнч(ПечДокумент)=Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
		ТипДок="СчетНаОплатуПокупателю";
	Иначе
		ТипДок="ЗаказПокупателя";
	КонецЕсли;
	
	ПараметрыПечати = Новый Структура;
	Позиции = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ПечДокумент);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Организация,
	|	Контрагент КАК Получатель,
	|	Организация КАК Руководители,
	|	Организация КАК Поставщик,
	|	СуммаДокумента,
	|	ВалютаДокумента,
	|	УчитыватьНДС,
	|	СуммаВключаетНДС
	|ИЗ
	|	Документ."+ТипДок+" КАК Документ
	|
	|ГДЕ
	|	Документ.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	СтрокаВыборкиПоляСодержания = ОбработкаТабличныхЧастей.ПолучитьЧастьЗапросаДляВыбораСодержания("ДокументПечати");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ПечДокумент);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура                    КАК Номенклатура,
	|	ВЫРАЗИТЬ (ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НаименованиеПолное,
	|	ВложенныйЗапрос.Номенклатура.Код                КАК Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул            КАК Артикул,
	|	ВложенныйЗапрос.Количество                      КАК Количество,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление  КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ПроцентСкидкиНаценки 
	|	+ ВложенныйЗапрос.ПроцентАвтоматическихСкидок   КАК Скидка,
	|	ВложенныйЗапрос.Цена                            КАК Цена,
	|	ВложенныйЗапрос.Сумма                           КАК Сумма,
	|	ВложенныйЗапрос.СуммаНДС                        КАК СуммаНДС,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	NULL                                            Как Серия,
	|	ВложенныйЗапрос.НомерСтроки                     КАК НомерСтроки,
	|	Метка
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		ДокументПечати.Номенклатура,
	|		ДокументПечати.ЕдиницаИзмерения,
	|		ДокументПечати.ПроцентСкидкиНаценки        КАК ПроцентСкидкиНаценки,
	|		ДокументПечати.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
	|		ДокументПечати.Цена                        КАК Цена,
	|		СУММА(ДокументПечати.Количество)           КАК Количество,
	|		СУММА(ДокументПечати.Сумма     )           КАК Сумма,
	|		СУММА(ДокументПечати.СуммаНДС  )           КАК СуммаНДС,
	|		ДокументПечати.ХарактеристикаНоменклатуры  КАК Характеристика,
	|		МИНИМУМ(ДокументПечати.НомерСтроки)        КАК НомерСтроки,
	|		0                                           КАК Метка
	|	ИЗ
	|		Документ."+ТипДок+".Товары КАК ДокументПечати
	|	ГДЕ
	|		ДокументПечати.Ссылка = &ТекущийДокумент
	|	СГРУППИРОВАТЬ ПО
	|		ДокументПечати.Номенклатура,
	|		ДокументПечати.ЕдиницаИзмерения,
	|		ДокументПечати.ПроцентСкидкиНаценки,
	|		ДокументПечати.ПроцентАвтоматическихСкидок,
	|		ДокументПечати.Цена,
	|		ДокументПечати.ХарактеристикаНоменклатуры
	|) КАК ВложенныйЗапрос
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ДокументПечати.Номенклатура,
	|	" + СтрокаВыборкиПоляСодержания + "                   КАК Товар,
	|	ДокументПечати.Номенклатура.Код                      КАК Код,
	|	ДокументПечати.Номенклатура.Артикул                  КАК Артикул,
	|	ДокументПечати.Количество                            КАК Количество,
	|	ДокументПечати.Номенклатура.ЕдиницаХраненияОстатков  КАК ЕдиницаИзмерения,
	|	ДокументПечати.ПроцентСкидкиНаценки
	|	+ ДокументПечати.ПроцентАвтоматическихСкидок         КАК Скидка,
	|	ДокументПечати.Цена                                  КАК Цена,
	|	ДокументПечати.Сумма                                 КАК Сумма,
	|	ДокументПечати.СуммаНДС                              КАК СуммаНДС,
	|	NULL                                                  КАК Характеристика,
	|	NULL                                                  КАК Серия,
	|	ДокументПечати.НомерСтроки                           КАК НомерСтроки,
	|	1                                                     КАК Метка
	|ИЗ
	|	Документ."+ТипДок+".Услуги КАК ДокументПечати
	|ГДЕ
	|	ДокументПечати.Ссылка = &ТекущийДокумент
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	ДокументПечати.Номенклатура                КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ДокументПечати.Номенклатура) КАК Товар,
	|	ДокументПечати.Номенклатура.Код            КАК Код,
	|	ДокументПечати.Номенклатура.Артикул        КАК Артикул,
	|	ДокументПечати.Количество                  КАК Количество,
	|	ДокументПечати.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	NULL                                        КАК Скидка,
	|	ДокументПечати.Цена                        КАК Цена,
	|	ДокументПечати.Сумма                       КАК Сумма,
	|	(0)                                         КАК СуммаНДС,
	|	NULL                                        КАК Характеристика,
	|	NULL                                        КАК Серия,
	|	ДокументПечати.НомерСтроки                 КАК НомерСтроки,
	|	3                                           КАК Метка
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		ДокументПечати.Номенклатура         КАК Номенклатура,
	|		СУММА(ДокументПечати.Количество)    КАК Количество,
	|		ДокументПечати.Цена                 КАК Цена,
	|		СУММА(ДокументПечати.Сумма)         КАК Сумма,
	|		МИНИМУМ(ДокументПечати.НомерСтроки) КАК НомерСтроки
	|	ИЗ
	|		Документ."+ТипДок+".ВозвратнаяТара КАК ДокументПечати
	|	ГДЕ
	|		ДокументПечати.Ссылка = &ТекущийДокумент
	|	СГРУППИРОВАТЬ ПО
	|		ДокументПечати.Номенклатура,
	|		ДокументПечати.Цена
	|) КАК ДокументПечати
	|УПОРЯДОЧИТЬ ПО Метка ВОЗР, НомерСтроки ВОЗР
	|";

	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	// Выводим шапку накладной

	ПараметрыПечати.Вставить("УчитыватьНДС", Шапка.УчитыватьНДС);
	СведенияОПоставщике = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
	ПараметрыПечати.Вставить("ИНН", СведенияОПоставщике.ИНН);
	ПараметрыПечати.Вставить("КПП", СведенияОПоставщике.КПП);
	ПредставлениеПоставщикаДляПлатПоручения = "";
	
	Если ТипЗнч(ПечДокумент.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета") И Не ОрганизацияВСписке(ПечДокумент.Организация.Наименование) Тогда
		Банк       = ПечДокумент.СтруктурнаяЕдиница.Банк;
		БИК        = Банк.Код;
		КоррСчет   = Банк.КоррСчет;
		ГородБанка = Банк.Город;
		НомерСчета = ПечДокумент.СтруктурнаяЕдиница.НомерСчета;
		
		ПараметрыПечати.Вставить("БИКБанкаПолучателя", БИК);
		ПараметрыПечати.Вставить("БанкПолучателя", Банк);
		ПараметрыПечати.Вставить("БанкПолучателяПредставление", СокрЛП(Банк) + " " + ГородБанка);
		ПараметрыПечати.Вставить("СчетБанкаПолучателя", КоррСчет);
		ПараметрыПечати.Вставить("СчетБанкаПолучателяПредставление", КоррСчет);
		ПараметрыПечати.Вставить("СчетПолучателяПредставление", НомерСчета);
		ПараметрыПечати.Вставить("СчетПолучателя", НомерСчета);
		ПредставлениеПоставщикаДляПлатПоручения = ПечДокумент.СтруктурнаяЕдиница.ТекстКорреспондента;
	КонецЕсли;
	Если ПустаяСтрока(ПредставлениеПоставщикаДляПлатПоручения) Тогда
		ПредставлениеПоставщикаДляПлатПоручения = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
	КонецЕсли;
	ПараметрыПечати.Вставить("ПредставлениеПоставщикаДляПлатПоручения", ПредставлениеПоставщикаДляПлатПоручения);

	ПараметрыПечати.Вставить("ТекстЗаголовка", ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Счет на оплату"));
	ПараметрыПечати.Вставить("ТекстПоставщик",  "Поставщик:");
	ПараметрыПечати.Вставить("ПредставлениеПоставщика", ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));
	СведенияОПолучателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
	ПараметрыПечати.Вставить("ТекстПокупатель", "Покупатель:");
	ПараметрыПечати.Вставить("ПредставлениеПолучателя", ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,"));

	ПараметрыПечати.Вставить("ЕстьСкидки", Ложь);
	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
		Если ЗначениеЗаполнено(ВыборкаСтрокТовары.Скидка) Тогда
			ПараметрыПечати.ЕстьСкидки = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	ПараметрыПечати.Вставить("ВыводитьКоды", Ложь);
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ПараметрыПечати.ВыводитьКоды = Истина;
		Колонка = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ПараметрыПечати.ВыводитьКоды = Истина;
		Колонка = "Код";
	КонецЕсли;
	
	Если ПараметрыПечати.ВыводитьКоды Тогда
		ПараметрыПечати.Вставить("ИмяКолонкиКодов", Колонка);
	КонецЕсли;

	Сумма    = 0;
	СуммаНДС = 0;
	ВсегоСкидок    = 0;
	ВсегоБезСкидок = 0;

	Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
		
		ПараметрыПозиции = Новый Структура;

		ПараметрыПозиции.Вставить("Номенклатура", ВыборкаСтрокТовары.Номенклатура);
		ПараметрыПозиции.Вставить("НомерСтроки", ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1);

		Если ПараметрыПечати.ВыводитьКоды Тогда
			Если Колонка = "Артикул" Тогда
				ПараметрыПозиции.Вставить("Артикул", ВыборкаСтрокТовары.Артикул);
			Иначе
				ПараметрыПозиции.Вставить("Артикул", ВыборкаСтрокТовары.Код);
			КонецЕсли;
		КонецЕсли;

		ПараметрыПозиции.Вставить("Количество", ВыборкаСтрокТовары.Количество);
		ПараметрыПозиции.Вставить("ЕдиницаИзмерения", ВыборкаСтрокТовары.ЕдиницаИзмерения);
		ПараметрыПозиции.Вставить("Цена", ВыборкаСтрокТовары.Цена);
		ПараметрыПозиции.Вставить("Товар", СокрП(ВыборкаСтрокТовары.НаименованиеПолное) 
														+ ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары)
														+ ?(ВыборкаСтрокТовары.Метка = 3, " (возвратная тара)", ""));

		Скидка = Ценообразование.ПолучитьСуммуСкидки(ВыборкаСтрокТовары.Сумма, ВыборкаСтрокТовары.Скидка);

		Если ПараметрыПечати.ЕстьСкидки Тогда
			ПараметрыПозиции.Вставить("Скидка", Скидка);
			ПараметрыПозиции.Вставить("СуммаБезСкидки", ВыборкаСтрокТовары.Сумма + Скидка);
		КонецЕсли;

		ПараметрыПозиции.Вставить("Сумма", ВыборкаСтрокТовары.Сумма); 
		
		Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
		СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;
		ВсегоСкидок    = ВсегоСкидок + Скидка;
		ВсегоБезСкидок = Сумма       + ВсегоСкидок;
		
		#Если ВнешнееСоединение Тогда
		WEBПриложения.ПодготовитьСтруктуруДляВнешнегоСоединения(ПараметрыПозиции);
		#КонецЕсли
		
		Позиции.Добавить(ПараметрыПозиции);

	КонецЦикла;
	
	ПараметрыПечати.Вставить("Позиции", Позиции);

	// Вывести Итого
	Если ПараметрыПечати.ЕстьСкидки Тогда
		ПараметрыПечати.Вставить("ВсегоСкидок", ВсегоСкидок);
		ПараметрыПечати.Вставить("ВсегоБезСкидок", ВсегоБезСкидок);
	КонецЕсли;
	ПараметрыПечати.Вставить("Всего", ОбщегоНазначения.ФорматСумм(Сумма));

	// Вывести ИтогоНДС
	Если ПараметрыПечати.УчитыватьНДС Тогда
		ПараметрыПечати.Вставить("НДС", ?(Шапка.СуммаВключаетНДС, "В том числе НДС:", "Сумма НДС:"));
		ПараметрыПечати.Вставить("ВсегоНДС", ОбщегоНазначения.ФорматСумм(ЗапросТовары.Итог("СуммаНДС")));
	КонецЕсли;

	// Вывести Сумму прописью
	СуммаКПрописи = Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
	ПараметрыПечати.Вставить("ИтоговаяСтрока", "Всего наименований " + ЗапросТовары.Количество()
	+ ", на сумму " + ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента));
	ПараметрыПечати.Вставить("СуммаПрописью", ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Шапка.ВалютаДокумента));

	// Вывести подписи
	Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизации(Шапка.Руководители, Шапка.Дата,);
	Руководитель = Руководители.Руководитель;
	Бухгалтер    = Руководители.ГлавныйБухгалтер;

	ПараметрыПечати.Вставить("ФИОРуководителя", "/" + Руководитель  + "/");
	ПараметрыПечати.Вставить("ФИОБухгалтера", "/" + Бухгалтер     + "/");
	ПараметрыПечати.Вставить("ФИООтветственный", "/" + ПечДокумент.Ответственный + "/");
	
	#Если ВнешнееСоединение Тогда
	WEBПриложения.ПодготовитьСтруктуруДляВнешнегоСоединения(ПараметрыПечати);
	#КонецЕсли

	Возврат ПараметрыПечати;

КонецФункции // ПолучитьПараметрыПечатиСчетаЗаказа()               

Функция ОрганизацияВСписке(НаимОрганизации)
	Для Каждого Эл Из ДополнительныеПараметры Цикл
		Если Эл.Значение=НаимОрганизации Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции
