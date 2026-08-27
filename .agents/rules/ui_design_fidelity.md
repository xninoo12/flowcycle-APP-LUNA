# FlowCycle UI Design Fidelity & Aesthetic Guidelines

1. **Design Reference Priority**: Always use the user-supplied UI mockups as the primary ground truth for hierarchy, relative sizing, control placement, card styling, and density.
2. **Premium Execution**: Maintain a serene, luxury women's health aesthetic. Use the FlowCycle Design System tokens strictly:
   - Background: Warm Cream (`#FAF7F2`)
   - Primary Accent: Primary Rose (`#E86A8D`) / Dawn Bloom Gradient
   - Surfaces: Crisp White (`#FFFFFF`) with subtle border (`#E8E2D9`) and soft elevation shadows (`AppShadows.card`).
3. **Standard Primary Action Buttons**:
   - Use the established `PrimaryButton` component.
   - Default to solid filled accent treatment (`AppGradients.dawnBloom` or `AppColors.primaryRose`) with white readable text (`AppColors.textInverse`).
   - Pill radius (`AppRadius.pill`) with full-width reachability.
4. **Interactive Asset Previews**:
   - Save generated visual previews directly to `assets/images/` and update `preview.html` so the user has immediate access to visual verification.
