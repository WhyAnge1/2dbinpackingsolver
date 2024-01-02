import 'package:bin_packing_problem_resolver/cubit/cubits/configuration_cubit.dart';
import 'package:bin_packing_problem_resolver/cubit/states/configuration_state.dart';
import 'package:bin_packing_problem_resolver/helpers/configuration.dart';
import 'package:bin_packing_problem_resolver/models/entity/bin_packing/rectangle_entity.dart';
import 'package:bin_packing_problem_resolver/resources/app_colors.dart';
import 'package:bin_packing_problem_resolver/ui/controls/generated_rectangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final cubit = ConfigurationCubit();
  final randomGeneratorAdvancedSegmentValues = {
    'manual': 'Manual',
    'random': 'Random'
  };
  final containerWidthTextEditingController = TextEditingController();
  final containerHeightTextEditingController = TextEditingController();
  final rectanglesCountTextEditingController = TextEditingController();
  final newRectangleWidthTextEditingController = TextEditingController();
  final newRectangleHeightTextEditingController = TextEditingController();
  final newRectangleNameTextEditingController = TextEditingController();
  late ValueNotifier<String> randomGeneratorAdvancedSegmentController;
  bool shouldShowRectanglesCountError = false;
  bool shouldShowContainerWidthError = false;
  bool shouldShowContainerHeightError = false;
  bool shouldShowRectangleWidthError = false;
  bool shouldShowRectangleHeightError = false;
  bool shouldShowRectangleNameError = false;

  @override
  void initState() {
    _setInitialValues();

    randomGeneratorAdvancedSegmentController = ValueNotifier(
        ConfigurationHolder.shouldUseRandomGeneration ? 'random' : 'manual');

    randomGeneratorAdvancedSegmentController.addListener(() =>
        cubit.setShouldUseRandomGeneration(
            randomGeneratorAdvancedSegmentController.value !=
                randomGeneratorAdvancedSegmentValues.keys.first));

    cubit.requestConfigurationRefresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Configuration",
                style: TextStyle(
                  color: AppColors.labelColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<ConfigurationCubit, ConfigurationState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is DataChangedConfigurationState,
                builder: (context, state) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is DataChangedConfigurationState)
                        _buildContainerConfiguration(),
                      const SizedBox(
                        width: 50,
                      ),
                      if (state is DataChangedConfigurationState)
                        _buildGeneratorConfiguration(state),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
              _buildGeneratedRectanglesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratedRectanglesSection() {
    return BlocBuilder<ConfigurationCubit, ConfigurationState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is GeneratedRectanglesConfigurationState,
      builder: (context, state) {
        return state is GeneratedRectanglesConfigurationState
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Generated ${state.rectangles.length} rectangles",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: AppColors.labelColor,
                            fontSize: 25,
                          ),
                        ),
                        Tooltip(
                          message: "Long tap on a rectangle to delete it",
                          child: Icon(
                            MdiIcons.alertCircle,
                            color: AppColors.iconGrayColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    _buildRectanglesGridView(state),
                  ],
                ),
              )
            : Container();
      },
    );
  }

  Widget _buildGeneratorConfiguration(DataChangedConfigurationState state) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rectangle generation",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.labelGrayTitleColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AdvancedSegment(
                      controller: randomGeneratorAdvancedSegmentController,
                      segments: randomGeneratorAdvancedSegmentValues,
                      activeStyle: const TextStyle(
                        color: AppColors.labelButtonColor,
                      ),
                      inactiveStyle: const TextStyle(
                        color: AppColors.buttonColor,
                      ),
                      backgroundColor: AppColors.backgroundColor,
                      sliderColor: AppColors.buttonColor,
                      sliderOffset: 3,
                      borderRadius: BorderRadius.circular(10),
                      animationDuration: const Duration(milliseconds: 250),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ...state.shouldUseRandomGeneration
                        ? [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Rectangles count",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: AppColors.labelGrayTitleColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: _trySetRectanglesCount,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            isDense: true,
                                          ),
                                          keyboardType: TextInputType.number,
                                          controller:
                                              rectanglesCountTextEditingController,
                                        ),
                                      ),
                                      AnimatedScale(
                                        scale: shouldShowRectanglesCountError
                                            ? 1
                                            : 0,
                                        duration:
                                            const Duration(milliseconds: 250),
                                        child: Tooltip(
                                          message:
                                              "Value should ba a number and be in range [1, 1000000]",
                                          child: Icon(
                                            MdiIcons.alertCircle,
                                            color: AppColors.errorColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            )
                          ]
                        : [],
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.buttonColor,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () => cubit.generateRectangles(),
                      child: const Text(
                        "Generate",
                        style: TextStyle(
                          color: AppColors.labelButtonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.labelGrayTitleColor,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: _onNewRectangleNameChanged,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                ),
                                controller:
                                    newRectangleNameTextEditingController,
                              ),
                            ),
                            AnimatedScale(
                              scale: shouldShowRectangleWidthError ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: Tooltip(
                                message:
                                    "Name should be maximum 10 symbols long",
                                child: Icon(
                                  MdiIcons.alertCircle,
                                  color: AppColors.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Width",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.labelGrayTitleColor,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) =>
                                    _onNewRectangleWidthChanged(
                                        value, state.containerWidth),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                controller:
                                    newRectangleWidthTextEditingController,
                              ),
                            ),
                            AnimatedScale(
                              scale: shouldShowRectangleWidthError ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: Tooltip(
                                message:
                                    "Value should ba a number and be in range [1, container width]",
                                child: Icon(
                                  MdiIcons.alertCircle,
                                  color: AppColors.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Height",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.labelGrayTitleColor,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) =>
                                    _onNewRectangleHeightChanged(
                                        value, state.containerHeight),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                controller:
                                    newRectangleHeightTextEditingController,
                              ),
                            ),
                            AnimatedScale(
                              scale: shouldShowRectangleHeightError ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: Tooltip(
                                message:
                                    "Value should ba a number and be in range [1, container height]",
                                child: Icon(
                                  MdiIcons.alertCircle,
                                  color: AppColors.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 38,
                          vertical: 18,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.buttonColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: _onAddRectanglePressed,
                    child: const Text(
                      "Add",
                      style: TextStyle(color: AppColors.labelButtonColor),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildContainerConfiguration() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Container width",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.labelGrayTitleColor,
                fontSize: 15,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _trySetContainerWidth,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                    ),
                    controller: containerWidthTextEditingController,
                  ),
                ),
                AnimatedScale(
                  scale: shouldShowContainerWidthError ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Tooltip(
                    message:
                        "Value should ba a number and be in range [1, 999]",
                    child: Icon(
                      MdiIcons.alertCircle,
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Container height",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromARGB(255, 79, 78, 103),
                fontSize: 15,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _trySetContainerHeight,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                    ),
                    controller: containerHeightTextEditingController,
                  ),
                ),
                AnimatedScale(
                  scale: shouldShowContainerHeightError ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Tooltip(
                    message:
                        "Value should ba a number and be in range [1, 999]",
                    child: Icon(
                      MdiIcons.alertCircle,
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRectanglesGridView(GeneratedRectanglesConfigurationState state) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: state.rectangles.map(
        (rectangle) {
          return GestureDetector(
            onLongPress: () => _onRemoveRectanglePressed(rectangle),
            child: GeneratedRectangle(
              rectangleName: rectangle.name,
              rectangleHeight: rectangle.height.toDouble(),
              rectangleWidth: rectangle.width.toDouble(),
              maxHeight: state.rectangleMaxHeight,
            ),
          );
        },
      ).toList(),
    );
  }

  void _trySetContainerWidth(String value) {
    var newWidth = double.tryParse(value);
    if (newWidth != null && newWidth > 0 && newWidth < 1000) {
      setState(() => shouldShowContainerWidthError = false);

      cubit.setContainerWidth(newWidth);
    } else {
      setState(() => shouldShowContainerWidthError = true);
    }
  }

  void _trySetContainerHeight(String value) {
    var newHeight = double.tryParse(value);
    if (newHeight != null && newHeight > 0 && newHeight < 1000) {
      setState(() => shouldShowContainerHeightError = false);

      cubit.setContainerHeight(newHeight);
    } else {
      setState(() => shouldShowContainerHeightError = true);
    }
  }

  void _trySetRectanglesCount(String value) {
    var newRectanglesCount = int.tryParse(value);
    if (newRectanglesCount != null &&
        newRectanglesCount > 0 &&
        newRectanglesCount <= 1000000) {
      setState(() => shouldShowRectanglesCountError = false);

      cubit.setGenerateRectanglesCount(newRectanglesCount);
    } else {
      setState(() => shouldShowRectanglesCountError = true);
    }
  }

  void _onNewRectangleWidthChanged(String value, double maxWidth) {
    var newWidth = double.tryParse(value);

    setState(() => shouldShowRectangleWidthError =
        newWidth == null || newWidth <= 0 || newWidth >= maxWidth);
  }

  void _onNewRectangleHeightChanged(String value, double maxHeight) {
    var newHeight = double.tryParse(value);

    setState(() => shouldShowRectangleHeightError =
        newHeight == null || newHeight <= 0 || newHeight >= maxHeight);
  }

  void _onNewRectangleNameChanged(String newName) {
    setState(() => shouldShowRectangleNameError = newName.length <= 10);
  }

  void _onAddRectanglePressed() {
    if (!shouldShowRectangleWidthError && !shouldShowRectangleHeightError) {
      cubit.addRectangle(
          newRectangleNameTextEditingController.text,
          double.parse(newRectangleWidthTextEditingController.text),
          double.parse(newRectangleHeightTextEditingController.text));
    }
  }

  void _onRemoveRectanglePressed(RectangleEntity rectangle) {
    cubit.removeRectangle(rectangle);
  }

  void _setInitialValues() {
    containerWidthTextEditingController.text =
        ConfigurationHolder.containerWidth.toString();
    containerHeightTextEditingController.text =
        ConfigurationHolder.containerHeight.toString();
    rectanglesCountTextEditingController.text =
        ConfigurationHolder.generateRectanglesCount.toString();
  }
}
