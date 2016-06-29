﻿// <Описание функции>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция Печать() Экспорт

	ЗапросОрганизация = Новый Запрос;
	
	ЗапросОрганизация.Текст =
    	       	
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление КАК АдресОрганизации
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО РеализацияТоваровУслуг.Организация = КонтактнаяИнформация.Объект
	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации))
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка = &ТекущийДокумент";
	
	ЗапросОрганизация.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект.Ссылка);
	
	ВыборкаОрганизация = ЗапросОрганизация.Выполнить().Выбрать();
	ВыборкаОрганизация.Следующий();
	
	ЗапросКонтрагент = Новый Запрос;
	
	ЗапросКонтрагент.Текст =
    	       	
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление КАК АдресКонтрагента
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО РеализацияТоваровУслуг.Контрагент = КонтактнаяИнформация.Объект
	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента))
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка = &ТекущийДокумент";
	
	ЗапросКонтрагент.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект.Ссылка);
	
	ВыборкаКонтрагент = ЗапросОрганизация.Выполнить().Выбрать();
	ВыборкаКонтрагент.Следующий();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
    "ВЫБРАТЬ
    |	РеализацияТоваровУслугТовары.Ссылка.Номер КАК НомерДокумента,
    |	РеализацияТоваровУслугТовары.Ссылка.Дата КАК ДатаДокумента,
    |	РеализацияТоваровУслугТовары.Ссылка.Организация.НаименованиеПолное КАК НаименованиеПолноеОрганизации,
    |	РеализацияТоваровУслугТовары.Ссылка.Контрагент.НаименованиеПолное КАК Заказчик,
    |	РеализацияТоваровУслугТовары.Номенклатура.Артикул КАК Артикул,
    |	РеализацияТоваровУслугТовары.Номенклатура.Наименование КАК Товар,
    |	РеализацияТоваровУслугТовары.Количество КАК Количество,
    |	РеализацияТоваровУслугТовары.Цена КАК Цена,
    |	РеализацияТоваровУслугТовары.Сумма КАК Сумма,
    |	РеализацияТоваровУслугТовары.СуммаНДС КАК СуммаНДС,
    |	РеализацияТоваровУслугТовары.Номенклатура.БазоваяЕдиницаИзмерения КАК ЕденицаИзмерения,
    |	РеализацияТоваровУслугТовары.Ссылка.ДоговорКонтрагента.Номер КАК НомерДоговора,
    |	РеализацияТоваровУслугТовары.Ссылка.ДоговорКонтрагента.Дата КАК ДатаДоговора
    |ИЗ
    |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
    |ГДЕ
    |	РеализацияТоваровУслугТовары.Ссылка = &ТекущийДокумент";
	
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ТабДокумент = Новый ТабличныйДокумент;

	ТабДокумент.ПолеСверху              = 0;
	ТабДокумент.ПолеСлева               = 5;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 5;
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеализацияТоваровУслуг_МХ1";
	
	Макет = ПолучитьМакет("Макет");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");                                                     
	ОбластьМакета.Параметры.ПредставлениеОрганизации = Выборка.НаименованиеПолноеОрганизации + ", " + ВыборкаОрганизация.АдресОрганизации;
	ОбластьМакета.Параметры.ПредставлениеКонтрагента = Выборка.Заказчик + ", " + ВыборкаКонтрагент.АдресОрганизации;
    ОбластьМакета.Параметры.НомерДокумента =  Выборка.НомерДокумента;
	ОбластьМакета.Параметры.ДатаДокумента =  Выборка.ДатаДокумента;
	ТабДокумент.Вывести(ОбластьМакета);
	
	Ном = 0;
	НомерСтраницы = 1;
	НомерСтроки = 0;
	ИтогоСумма = 0;
	ИтогоКоличество = 0;
	ИтогоСуммаПоСтранице = 0;
	ИтогоКоличествоПоСтранице = 0;
	КоличествоСтрок = Выборка.Количество();
	
	МассивВыводимыхОбластей = Новый Массив;
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьМакетаИтогоПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
	ОбластьМакетаИтого = Макет.ПолучитьОбласть("Итого");
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Выборка.Сбросить();
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтроки = НомерСтроки + 1;
		Ном         = Ном + 1;
		
		ОбластьМакетаСтрока.Параметры.НомерСтроки = НомерСтроки;              
		ОбластьМакетаСтрока.Параметры.Заполнить(Выборка);
		
		Если Ном = 1 Тогда // первая срока
			
			ОбластьМакетаШапка.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
			ТабДокумент.Вывести(ОбластьМакетаШапка);
			
		Иначе
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаСтрока);
			МассивВыводимыхОбластей.Добавить(ОбластьМакетаИтогоПоСтранице);
			Если Ном = КоличествоСтрок Тогда
				МассивВыводимыхОбластей.Добавить(ОбластьМакетаИтого);
				МассивВыводимыхОбластей.Добавить(ОбластьМакетаПодвал);
			КонецЕсли;	
			
			Если Ном <> 1 И НЕ ТабДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоКоличествоПоСтранице = ИтогоКоличествоПоСтранице;
				ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоСуммаПоСтранице = ИтогоСуммаПоСтранице;
				ТабДокумент.Вывести(ОбластьМакетаИтогоПоСтранице);
				
				ИтогоКоличествоПоСтранице = 0;
				ИтогоСуммаПоСтранице = 0;
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ОбластьМакетаШапка.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
				ТабДокумент.Вывести(ОбластьМакетаШапка);
			КонецЕсли;
			
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакетаСтрока);
		
		ИтогоКоличествоПоСтранице = ИтогоКоличествоПоСтранице + Выборка.Количество;
		ИтогоСуммаПоСтранице = ИтогоСуммаПоСтранице + Выборка.Сумма;

		ИтогоСумма = ИтогоСумма + Выборка.Сумма; 
		ИтогоКоличество = ИтогоКоличество + Выборка.Количество;

	КонецЦикла;
	//
	ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоКоличествоПоСтранице = ИтогоКоличествоПоСтранице;
	ОбластьМакетаИтогоПоСтранице.Параметры.ИтогоСуммаПоСтранице = ИтогоСуммаПоСтранице;
	ТабДокумент.Вывести(ОбластьМакетаИтогоПоСтранице);
	
	ОбластьМакетаИтого.Параметры.ИтогоСумма = ИтогоСумма;	
	ОбластьМакетаИтого.Параметры.ИтогоКоличество =  ИтогоКоличество;

	ТабДокумент.Вывести(ОбластьМакетаИтого);
	ТабДокумент.Вывести(ОбластьМакетаПодвал);

	Возврат ТабДокумент;

КонецФункции // Печать() 