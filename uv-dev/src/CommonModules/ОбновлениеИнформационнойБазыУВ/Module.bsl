
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя = "УправлениеВитриной";
	Описание.Версия = "1.0.1.1";
	
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыУВ.СозданиеКонтактнойИнформации";
	
КонецПроцедуры

Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
КонецПроцедуры

Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновления ИБ для справочника видов контактной информации
Процедура СозданиеКонтактнойИнформации(Параметры) Экспорт
	
	// Справочник "Покупатели"
	ГруппаКонтактнойИнформации     = УправлениеКонтактнойИнформацией.ПараметрыГруппыВидаКонтактнойИнформации();
	ГруппаКонтактнойИнформации.Имя = "СправочникПокупатели";
	ГруппаКонтактнойИнформации.Наименование = НСтр("ru='Контактная информация справочника ""Покупатели""'");
	
	Группа = УправлениеКонтактнойИнформацией.УстановитьСвойстваГруппыВидаКонтактнойИнформации(ГруппаКонтактнойИнформации);
	
	Вид = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	Вид.Имя = "ТелефонПокупателя";
	Вид.Наименование = НСтр("ru = 'Телефон'");
	Вид.Порядок = 1;
	Вид.Группа = Группа;
	Вид.МожноИзменятьСпособРедактирования = Ложь;
	Вид.РазрешитьВводНесколькихЗначений   = Ложь;
	Вид.ОтображатьВсегда                  = Истина;
	Вид.НастройкиПроверки.ВводитьНомерПоМаске = Истина;
	Вид.НастройкиПроверки.МаскаНомераТелефона = "9 (999) 999 99 99";
	Вид.НастройкиПроверки.ТелефонCДобавочнымНомером = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(Вид);
	
	Вид = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Вид.Имя = "EmailПокупателя";
	Вид.Наименование = НСтр("ru = 'Электронная почта'");
	Вид.Порядок = 2;
	Вид.Группа = Группа;
	Вид.МожноИзменятьСпособРедактирования = Ложь;
	Вид.РазрешитьВводНесколькихЗначений   = Ложь;
	Вид.ОтображатьВсегда                  = Истина;
	Вид.НастройкиПроверки.ПроверятьКорректность = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(Вид);
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти
