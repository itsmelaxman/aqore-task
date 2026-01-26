import 'package:aqore_app/app_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessSetupView extends GetView<BusinessSetupController> {
  const BusinessSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .all(24),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Gaps.verticalGapOf(40),
            Center(
              child: Container(
                width: .infinity,
                height: 120,
                margin: .symmetric(horizontal: 60),
                padding: .all(24),
                decoration: BoxDecoration(
                  color: context.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: SvgHelper.fromSource(
                  path: Assets.businessOutlined,
                  height: 40,
                  width: 40,
                  color: context.primaryColor,
                ),
              ),
            ),
            Gaps.verticalGapOf(24),
            Text(
              'Welcome to Aqore',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: .bold),
              textAlign: .center,
            ),
            Gaps.verticalGapOf(12),
            Text(
              'Let\'s set up your business profile to get started',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.onSurfaceColor.withValues(alpha: 0.7),
              ),
              textAlign: .center,
            ),
            Gaps.verticalGapOf(48),
            Expanded(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Organization Name',
                      hint: 'Enter your organization name',
                      controller: controller.businessNameController,
                      prefixIcon: Assets.businessOutlined,
                      textInputAction: .done,
                      validator: (value) => Validators.required(
                        value,
                        fieldName: 'Organization Name',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gaps.verticalGapOf(12),
            CustomMaterialButton(
              label: 'Get Started',
              icon: Icons.arrow_forward,
              onTap: controller.saveBusiness,
            ),
          ],
        ),
      ),
    );
  }
}
