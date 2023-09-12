///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает признак использования внешних пользователей в программе
// (значение функциональной опции ИспользоватьВнешнихПользователей).
//
// Возвращаемое значение:
//  Булево - если Истина, внешние пользователи включены.
//
Функция ИспользоватьВнешнихПользователей() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	
КонецФункции

// Возвращает текущего внешнего пользователя.
//  Рекомендуется использовать в коде, который поддерживает только внешних пользователей.
//
//  Если вход в сеанс выполнил не внешний пользователь, тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеПользователи - внешний пользователь.
//
Функция ТекущийВнешнийПользователь() Экспорт
	
	Возврат ПользователиСлужебныйКлиентСервер.ТекущийВнешнийПользователь(
		Пользователи.АвторизованныйПользователь());
	
КонецФункции

// Возвращает ссылку на объект авторизации внешнего пользователя, полученный из информационной базы.
// Объект авторизации - это ссылка на объект информационной базы, используемый
// для связи с внешним пользователем, например: контрагент, физическое лицо и т.д.
//
// Параметры:
//  ВнешнийПользователь - Неопределено - используется текущий внешний пользователь.
//                      - СправочникСсылка.ВнешниеПользователи - указанный внешний пользователь.
//
// Возвращаемое значение:
//  ЛюбаяСсылка - объект авторизации одного из типов, указанных в описании типов в свойстве
//           "Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектыАвторизации.Тип".
//
Функция ПолучитьОбъектАвторизацииВнешнегоПользователя(ВнешнийПользователь = Неопределено) Экспорт
	
	Если ВнешнийПользователь = Неопределено Тогда
		ВнешнийПользователь = ТекущийВнешнийПользователь();
	КонецЕсли;
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВнешнийПользователь, "ОбъектАвторизации").ОбъектАвторизации;
	
	Если ЗначениеЗаполнено(ОбъектАвторизации) Тогда
		Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(ОбъектАвторизации, ВнешнийПользователь) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Объект авторизации ""%1"" (%2)
					|установлен для нескольких внешних пользователей.'"),
				ОбъектАвторизации,
				ТипЗнч(ОбъектАвторизации));
		КонецЕсли;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для внешнего пользователя ""%1"" не задан объект авторизации.'"),
			ВнешнийПользователь);
	КонецЕсли;
	
	Возврат ОбъектАвторизации;
	
КонецФункции

// Используется для настройки отображения состояния внешних пользователей
// в списках справочников (партнеры, респонденты и др.), которые
// являются объектом авторизации в справочнике ВнешниеПользователи.
// 
// Когда нет прав к справочнику ВнешниеПользователи или он не используется, тогда
// отключается видимость колонки ВнешнийДоступ и легенды ВнешнийДоступЛегенда.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ДополнительныеПараметры - см. ПараметрыНастройкиОтображенияСпискаВнешнихПользователей
//
Процедура НастроитьОтображениеСпискаВнешнихПользователей(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ПараметрыНастройкиОтображенияСпискаВнешнихПользователей();
	КонецЕсли;
	
	Список = Форма[ДополнительныеПараметры.ИмяСписка];
	ПользователиСлужебный.ОграничитьИспользованиеЗаполняемогоПоляДинамическогоСписка(Список,
		ДополнительныеПараметры.ИмяПоля);
	
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи)
	   И ИспользоватьВнешнихПользователей() Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = Форма.Элементы.Найти(ДополнительныеПараметры.ИмяЭлемента);
	Если Элемент <> Неопределено Тогда
		Элемент.Видимость = Ложь;
	КонецЕсли;
	
	Элемент = Форма.Элементы.Найти(ДополнительныеПараметры.ИмяГруппыЛегенды);
	Если Элемент <> Неопределено Тогда
		Элемент.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	// Удаление отображения недоступных сведений.
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Список.ТекстЗапроса);
	Источники = СхемаЗапроса.ПакетЗапросов[0].Операторы[0].Источники; // ИсточникиСхемыЗапроса
	Для Индекс = 0 По Источники.Количество() - 1 Цикл
		Если Источники[Индекс].Источник.ИмяТаблицы = "Справочник.ВнешниеПользователи" Тогда
			Источники.Удалить(Индекс);
		КонецЕсли;
	КонецЦикла;
	Список.ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
КонецПроцедуры

// Конструктор дополнительных параметров процедуры НастроитьОтображениеСпискаВнешнихПользователей.
//
// Возвращаемое значение:
//  Структура:
//   * ИмяСписка        - Строка - имя реквизита формы с динамическим списком.
//   * ИмяПоля          - Строка - имя поля запроса динамического списка.
//   * ИмяЭлемента      - Строка - имя элемента формы колонки динамического списка.
//   * ИмяГруппыЛегенды - Строка - имя элемента формы, содержащую легенду состояний внешнего доступа.
//
Функция ПараметрыНастройкиОтображенияСпискаВнешнихПользователей() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяСписка",        "Список");
	Результат.Вставить("ИмяПоля",          "ВнешнийДоступНомерКартинки");
	Результат.Вставить("ИмяЭлемента",      "ВнешнийДоступНомерКартинки");
	Результат.Вставить("ИмяГруппыЛегенды", "ВнешнийДоступЛегенда");
	
	Возврат Результат;
	
КонецФункции

// Используется для заполнения значений поля состояния внешних пользователей
// в списках справочников (партнеры, респонденты и др.), которые
// являются объектом авторизации в справочнике ВнешниеПользователи.
//
// Вызов выполняется из события ПриПолученииДанныхНаСервере динамического списка
// справочника, при этом заполняется поле ВнешнийДоступ на основе данных поля Ссылка.
//
// Параметры:
//  ИмяЭлемента - Строка
//  Настройки - НастройкиКомпоновкиДанных
//  Строки - СтрокиДинамическогоСписка
//  ИмяПоля - Строка - имя поля номера картинки строк в динамическом списке.
//
Процедура СписокВнешнихПользователейПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки,
			ИмяПоля = "ВнешнийДоступНомерКартинки") Экспорт
	
	Если Строки.Количество() = 0
	 Или Не ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Строки Цикл
		Свойства = Новый Структура("Ссылка" + "," + ИмяПоля);
		ЗаполнитьЗначенияСвойств(Свойства, КлючИЗначение.Значение.Данные);
		Если КлючИЗначение.Ключ <> Свойства.Ссылка
		 Или ТипЗнч(Свойства[ИмяПоля]) <> Тип("Число") Тогда
			Возврат;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектыАвторизации", Строки.ПолучитьКлючи());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнешниеПользователи.ОбъектАвторизации КАК ОбъектАвторизации,
	|	СведенияОПользователях.НомерКартинкиСостояния - 1 КАК НомерКартинки
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|		ПО (СведенияОПользователях.Пользователь = ВнешниеПользователи.Ссылка)
	|ГДЕ
	|	ВнешниеПользователи.ОбъектАвторизации В(&ОбъектыАвторизации)";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		Строка = Строки.Получить(Выборка.ОбъектАвторизации);
		Строка.Данные[ИмяПоля] = Выборка.НомерКартинки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
